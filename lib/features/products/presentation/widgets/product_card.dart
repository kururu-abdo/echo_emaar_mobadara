import 'dart:developer';

import 'package:echoemaar_commerce/config/constants/api_constants.dart';
import 'package:echoemaar_commerce/config/routes/route_names.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/size_utils.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  
  const ProductCard({super.key, required this.product});
  
  @override
  Widget build(BuildContext context) {
    // Easy access to all theme values
    final colors = context.colors;
    final spacing = context.spacing;
    final shapes = context.shapes;
    log(   ApiConstants.odooBaseUrl+ product.imageUrl??'');
    return GestureDetector(
      onTap: () {
        // Handle product card tap, e.g., navigate to product details
        Navigator.of(context).pushNamed(RouteNames.productDetail, arguments:  product.id.toString());

      },
      child: Card(
        elevation: 2,
        shadowColor: colors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(shapes.borderRadiusMedium),
              ),
              child: Image.network(
               ApiConstants.odooBaseUrl+ product.imageUrl??'',
                height: context.heightPercent(20),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            Padding(
              padding: spacing.paddingMD,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: TextStyles.bodyLarge(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  spacing.verticalSM,
                  
                  // Price
                  Row(
                    children: [
                      if (product.isOnSale) ...[
                        Text(
                          '\$${product.listPrice}',
                          style: TextStyles.priceStrikethrough(context),
                        ),
                        spacing.horizontalSM,
                      ],
                      Text(
                        '\$${product.effectivePrice}',
                        style: TextStyles.price(context),
                      ),
                    ],
                  ),
                  
                  spacing.verticalSM,
                  
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: context.buttonHeight(mobile: 40),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
                        ),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyles.button(context, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}