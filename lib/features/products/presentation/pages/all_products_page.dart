// lib/features/shop/presentation/pages/all_products_page.dart

import 'package:echoemaar_commerce/features/products/data/models/product_model.dart';
import 'package:echoemaar_commerce/features/products/presentation/widgets/all_products_shimmer.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/product_card_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/filter_bottom_sheet.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  // ملاحظة: لا يوجد Provider هنا بناءً على تعليماتك، سنستخدم متغير حالة محلي للـ Fake Implementation
  String _viewState = 'loading'; // 'loading', 'loaded', 'error'

  @override
  void initState() {
    super.initState();
    _loadFakeData();
  }

  void _loadFakeData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _viewState = 'loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTopActionHeader(),
          Expanded(
            child: _buildBodyByState(),
          ),
        ],
      ),
    );
  }

  // --- Header & AppBar ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text('All Fixtures', style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF004D7A)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search, color: Color(0xFF004D7A)), onPressed: () {}),
      ],
    );
  }

  Widget _buildTopActionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('124 Products Found', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
          GestureDetector(
            onTap: () => _showFilterSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8)),
              child: const Row(
                children: [
                  Icon(Icons.filter_list, size: 16),
                  SizedBox(width: 8),
                  Text('Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- State Handler (Fake Implementation) ---
  Widget _buildBodyByState() {
    switch (_viewState) {
      case 'loading':
        return const AllProductsShimmer();
      case 'error':
        return _buildErrorView();
      case 'loaded':
      default:
        return _buildProductGrid();
    }
  }
void _showFilterSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FilterBottomSheet(),
  );
}

  Widget _buildErrorView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_off_outlined, size: 80, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        const Text('Unable to load products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('Please check your internet connection', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004D7A)),
          onPressed: () {
            setState(() => _viewState = 'loading');
            _loadFakeData();
          },
          child: const Text('Try Again'),
        ),
      ],
    ),
  );
}

Widget _buildProductGrid() {
  return GridView.builder(
    padding: const EdgeInsets.all(20),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.7,
    ),
    itemCount: 10,
    itemBuilder: (context, index) {
      // هنا نمرر بيانات المنتج الوهمي
      return ProductCardItem(
        product: ProductModel(
          id: index,
          name: 'Fixture Model ${index + 1}',
          category: 'Category Name',
          price: 450.0 + (index * 100),
          imageUrl: '',
          color: 'Chrome', defaultCode: '', barcode: '', uomName: '', qtyAvailable: 4, virturalAvaiable: 4,
        ),
      );
    },
  );
}
}