// lib/features/search/presentation/pages/search_page.dart
import 'package:echoemaar_commerce/features/products/domain/entities/product.dart';
import 'package:echoemaar_commerce/features/products/presentation/widgets/search_bar_widget.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/advanced_filters_widget.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/color_finishes_selector.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/price_range_filter.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/product_grid_card.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/recent_searches_widget.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/recommended_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../products/presentation/widgets/product_grid.dart';
import '../providers/search_provider.dart';
// استيراد باقي الـ widgets...


class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF004D7A)),
          onPressed: () {},
        ),
        title: const Text(
          'مبادرة صدى الإعمار',
          style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF004D7A)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<SearchProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end, // للغة العربية
              children: [
                 SearchBarWidget(controller: TextEditingController(), onChanged: (str) {  },),
                
                const AdvancedFiltersHeader(),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('اللون واللمسة النهائية', 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                const ColorFinishesSelector(),
                
                const PriceRangeSlider(),
                
                const RecentSearchesWrap(),
                
                const RecommendedBanner(),
                
                _buildProductGrid(provider),
                
                const SizedBox(height: 40),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildProductGrid(SearchProvider provider) {
    return
                      ProductCardGrid(products: provider.filteredProducts);

    
    // GridView.builder(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     childAspectRatio: 0.8,
    //     crossAxisSpacing: 16,
    //     mainAxisSpacing: 16,
    //   ),
    //   itemCount: 2,
    //   itemBuilder: (context, index) {
    //     return index == 0 
    //       ? const ProductGridItem(product: Product(id: 1, name: name, defaultCode: defaultCode, barcode: barcode, qtyAvailable: qtyAvailable, virturalAvaiable: virturalAvaiable, uomName: uomName, category: category, imageUrl: imageUrl), onTap: () {  }, onFavoriteToggle: () {  },)
    //       : const ProductGridItem(title: 'حوض سيراميك نورديك', price: '1,450 ر.س', category: 'أحواض', image: 'assets/basin.png');
    //   },
    // );
  }
}

/*
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


*/