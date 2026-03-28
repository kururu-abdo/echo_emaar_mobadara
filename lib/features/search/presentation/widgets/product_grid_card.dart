// lib/features/search/presentation/widgets/product_card_grid.dart
import 'package:echoemaar_commerce/features/products/data/models/product_model.dart';
import 'package:echoemaar_commerce/features/search/presentation/widgets/product_card_item.dart';
import 'package:flutter/material.dart';

class ProductCardGrid extends StatelessWidget {
  final List<ProductModel> products;
  const ProductCardGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text("لا توجد منتجات مطابقة للبحث"));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: .9,
        mainAxisSpacing: 20 , crossAxisSpacing: 10
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCardItem(product: product); // تمرير المنتج المفرد
      },
    );
  }
}