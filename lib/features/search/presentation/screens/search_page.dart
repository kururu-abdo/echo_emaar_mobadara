// lib/features/search/presentation/pages/search_page.dart
import 'package:echoemaar_commerce/features/products/presentation/widgets/search_bar_widget.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/advanced_filters_widget.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/product_grid_card.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/recent_searches_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
// استيراد باقي الـ widgets...

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات عند فتح الشاشة
    Future.microtask(() => context.read<SearchProvider>().fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SearchProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return SingleChildScrollView(
              child: Column(
                children: [
                  SearchBarWidget(onChanged: provider.searchProducts, controller: TextEditingController(),),
                  const AdvancedFiltersWidget(), // سيتم تحديثها أيضاً لتستخدم Provider
                  const RecentSearchesWidget(),
                  // تمرير المنتجات المفلترة للـ Grid
                  ProductCardGrid(products: provider.filteredProducts),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}