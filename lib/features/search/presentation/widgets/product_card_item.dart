// lib/features/search/presentation/widgets/product_card_item.dart
import 'package:echoemaar_commerce/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCardItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCardItem({
    super.key, 
    required this.product, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // الألوان المستوحاة من هوية Aqua Artisan
    const brandBlue = Color(0xFF1D71A4);
    const textGrey = Color(0xFF718096);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // اتجاه عربي
          children: [
            // 1. صورة المنتج مع زر المفضلة
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Hero(
                      tag: 'product_${product.id}',
                      child: Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        // في حالة فشل التحميل تظهر صورة مؤقتة (Placeholder)
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(Icons.image_not_supported_outlined, color: brandBlue),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8, // عكس الاتجاه للعربية
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withOpacity(0.8),
                      child: const Icon(Icons.favorite_border, size: 18, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

            // 2. تفاصيل المنتج
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.category,
                      style: const TextStyle(color: textGrey, fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // زر إضافة للسلة سريع
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: brandBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_shopping_cart, size: 18, color: brandBlue),
                        ),
                        // السعر
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${product.listPrice} ',
                                style: const TextStyle(
                                  color: brandBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const TextSpan(
                                text: 'ر.س',
                                style: TextStyle(color: brandBlue, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}