// lib/features/search/presentation/providers/search_provider.dart
import 'package:echoemaar_commerce/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProvider extends ChangeNotifier {
 List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<String> _searchHistory = [];
  
  bool _isLoading = false;
  String _selectedColor = ''; // اللون المختار حالياً
  
  // Getters
  List<ProductModel> get filteredProducts => _filteredProducts;
  List<String> get searchHistory => _searchHistory;
  bool get isLoading => _isLoading;
  String get selectedColor => _selectedColor;
// فلاتر الحالة
  RangeValues _priceRange = const RangeValues(500, 4500); // القيم الافتراضية حسب التصميم
  String _searchQuery = '';

  // Getters
  RangeValues get priceRange => _priceRange;
  SearchProvider() {
    _loadHistory(); // تحميل السجل عند إنشاء البروفايدر
  }

  // --- منطق الألوان (Dynamic Color Filter) ---
  void setColorFilter(String colorName) {
    if (_selectedColor == colorName) {
      _selectedColor = ''; // إلغاء الفلتر إذا ضغط عليه مرة ثانية
      _filteredProducts = _allProducts;
    } else {
      _selectedColor = colorName;
      _filteredProducts = _allProducts
          .where((p) => p.name == colorName)
          .toList();
    }
    notifyListeners();
  }

  // --- منطق السجل (Search History with Prefs) ---
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _searchHistory = prefs.getStringList('search_history') ?? [];
    notifyListeners();
  }

  Future<void> addToHistory(String query) async {
    if (query.isEmpty || _searchHistory.contains(query)) return;
    
    _searchHistory.insert(0, query);
    if (_searchHistory.length > 5) _searchHistory.removeLast(); // حفظ آخر 5 عمليات فقط
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
    notifyListeners();
  }

  Future<void> removeFromHistory(String query) async {
    _searchHistory.remove(query);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
    notifyListeners();
  }

  // دالة البحث الأساسية
  void searchProducts(String query) {
    if (query.isNotEmpty) addToHistory(query);
    
    _filteredProducts = _allProducts
        .where((p) => p.name.contains(query) || p.category.contains(query))
        .toList();
    notifyListeners();
  }
  
  // دالة جلب البيانات الأصلية (تستدعى في initState)
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    // محاكاة API
    await Future.delayed(const Duration(milliseconds: 500));
    _allProducts = [
      const ProductModel(id: 1, name: 'خلاط مغسلة تركي', category: 'صنابير', price: 1200, imageUrl: '', color: 'كروم', defaultCode: '', barcode: '', uomName: '', qtyAvailable: 4, virturalAvaiable: 4),
      const ProductModel(id: 2, name: 'رأس دش مطفي', category: 'دش استحمام', price: 850, imageUrl: '', color: 'أسود', defaultCode: '', barcode: '', uomName: '', qtyAvailable: 4, virturalAvaiable: 4),
    ];
    _filteredProducts = _allProducts;
    _isLoading = false;
    notifyListeners();
  }

  // --- دالة تطبيق الفلاتر الموحدة ---
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      // 1. فحص نص البحث
      final matchesQuery = product.name.contains(_searchQuery);
      
      // 2. فحص اللون المختارة
      final matchesColor = _selectedColor.isEmpty || product.name == _selectedColor;
      
      // 3. فحص نطاق السعر
      final matchesPrice = product.listPrice >= _priceRange.start && product.listPrice <= _priceRange.end;

      return matchesQuery && matchesColor && matchesPrice;
    }).toList();
    
    notifyListeners();
  }
// تحديث اللون
  void updateColor(String colorName) {
    _selectedColor = (_selectedColor == colorName) ? '' : colorName;
    _applyFilters();
  }
  // تحديث نطاق السعر
  void updatePriceRange(RangeValues newRange) {
    _priceRange = newRange;
    _applyFilters();
  }

  // تحديث نص البحث
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }
}