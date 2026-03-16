import 'package:echoemaar_commerce/features/products/data/models/product_model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<ProductModel?> getCachedProductDetails(int productId);
  Future<void> cacheProductDetails(ProductModel product);
  // Future<List<CategoryModel>> getCachedCategories();
  // Future<void> cacheCategories(List<CategoryModel> categories);

  Future<List<String>> getSearchHistory();
  Future<void> addSearchQuery(String query);
  Future<void> removeSearchQuery(String query);
  Future<void> clearSearchHistory();




  Future<void> clearCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String productsBoxName = 'products';
  static const String categoriesBoxName = 'categories';
    final SharedPreferences prefs;
  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final box = await Hive.openBox<Map>(productsBoxName);
    final productMaps = box.values.toList();
    return productMaps
        .map((map) => ProductModel.fromJson(Map<String, dynamic>.from(map)))
        .toList();
  }
  
  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final box = await Hive.openBox<Map>(productsBoxName);
    await box.clear();
    for (var product in products) {
      await box.put(product.id, product.toJson());
    }
  }
  
  @override
  Future<ProductModel?> getCachedProductDetails(int productId) async {
    final box = await Hive.openBox<Map>(productsBoxName);
    final productMap = box.get(productId);
    if (productMap == null) return null;
    return ProductModel.fromJson(Map<String, dynamic>.from(productMap));
  }
  
  @override
  Future<void> cacheProductDetails(ProductModel product) async {
    final box = await Hive.openBox<Map>(productsBoxName);
    await box.put(product.id, product.toJson());
  }
  /*
  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    final box = await Hive.openBox<Map>(categoriesBoxName);
    final categoryMaps = box.values.toList();
    return categoryMaps
        .map((map) => CategoryModel.fromJson(Map<String, dynamic>.from(map)))
        .toList();
  }
  
  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final box = await Hive.openBox<Map>(categoriesBoxName);
    await box.clear();
    for (var category in categories) {
      await box.put(category.id, category.toJson());
    }
  }

  */
  



  static const String _kSearchHistory = 'SEARCH_HISTORY';
  static const int _maxHistoryItems = 10;

  ProductLocalDataSourceImpl({required this.prefs});

  // SearchHistoryLocalDataSourceImpl({required this.prefs});

  @override
  Future<List<String>> getSearchHistory() async {
    try {
      final history = prefs.getStringList(_kSearchHistory) ?? [];
      return history;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addSearchQuery(String query) async {
    try {
      if (query.trim().isEmpty) return;

      final history = await getSearchHistory();
      
      // Remove if exists (to move to top)
      history.remove(query);
      
      // Add to beginning
      history.insert(0, query);
      
      // Keep only max items
      if (history.length > _maxHistoryItems) {
        history.removeRange(_maxHistoryItems, history.length);
      }
      
      await prefs.setStringList(_kSearchHistory, history);
    } catch (e) {
      // Fail silently
    }
  }

  @override
  Future<void> removeSearchQuery(String query) async {
    try {
      final history = await getSearchHistory();
      history.remove(query);
      await prefs.setStringList(_kSearchHistory, history);
    } catch (e) {
      // Fail silently
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      await prefs.remove(_kSearchHistory);
    } catch (e) {
      // Fail silently
    }
  }
  @override
  Future<void> clearCache() async {
    final productsBox = await Hive.openBox<Map>(productsBoxName);
    final categoriesBox = await Hive.openBox<Map>(categoriesBoxName);
    await productsBox.clear();
    await categoriesBox.clear();
  }
}