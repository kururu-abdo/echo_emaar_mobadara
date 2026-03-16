import 'package:echoemaar_commerce/config/constants/api_constants.dart';
import 'package:echoemaar_commerce/config/constants/app_constants.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/orientation_utils.dart';
import 'package:echoemaar_commerce/core/utilities/responsive_utils.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/core/widgets/shimmer_widget.dart';
import 'package:echoemaar_commerce/features/products/domain/entities/product.dart';
import 'package:echoemaar_commerce/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/product.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;
  
  const ProductGridItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavoriteToggle,
    this.isFavorite = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.shapes.borderRadiusMedium),
      child: Card(
        elevation: 2,
        shadowColor: context.colors.shadow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.shapes.borderRadiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Badges
            Expanded(
              flex: 3,
              child: _ProductImage(
                product: product,
                onFavoriteToggle: onFavoriteToggle,
                isFavorite: isFavorite,
              ),
            ),
            
            // Product Details
            Expanded(
              flex: 2,
              child: _ProductDetails(product: product),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Product product;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;
  
  const _ProductImage({
    required this.product,
    required this.onFavoriteToggle,
    required this.isFavorite,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        // Main Image
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.shapes.borderRadiusMedium),
          ),
          child: CachedNetworkImage(
            imageUrl:  
            
     product.imageUrl ?? '',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const ShimmerWidget(
              width: double.infinity,
              height: double.infinity,
            ),
            errorWidget: (context, url, error) => Container(
              color: context.colors.surfaceVariant,
              child: Icon(
                Icons.image_not_supported,
                size: 40,
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ),
       
        // Discount Badge
        if (product.isOnSale)
          Positioned(
            top: context.spacing.sm,
            left: context.spacing.sm,
            child: _DiscountBadge(
              discountPercentage: product.discountPercentage,
            ),
          ),
        
        // Stock Badge
        if (!(product.active??false))
          Positioned(
            top: context.spacing.sm,
            right: context.spacing.sm,
            child: _StockBadge(),
          ),
        
        // Favorite Button
        Positioned(
          bottom: context.spacing.sm,
          right: context.spacing.sm,
          child:
          
          
          
           _FavoriteButton(
            isFavorite: isFavorite,
            onToggle: onFavoriteToggle,
          ),
        ),
      ],
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final Product product;
  
  const _ProductDetails({required this.product});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.spacing.paddingSM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Product Name
          Text(
            product.name,
            style: TextStyles.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const Spacer(),
          
          // Category
          // Text(
          //   product.category,
          //   style: TextStyles.caption(context),
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          // ),
          
          SizedBox(height: context.spacing.xs),
          
          // Rating
          // if (product.rating != null)
          //   _RatingWidget(
          //     rating: product.rating!,
          //     reviewCount: product.reviewCount,
          //   ),
          
          SizedBox(height: context.spacing.xs),
          
          // Price
          _PriceWidget(product: product),
        ],
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final double discountPercentage;
  
  const _DiscountBadge({required this.discountPercentage});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.sm,
        vertical: context.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.error,
        borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
      ),
      child: Text(
        '-${discountPercentage.toStringAsFixed(0)}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.sm,
        vertical: context.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.textSecondary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
      ),
      child: const Text(
        'Out of Stock',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onToggle;
  
  const _FavoriteButton({
    required this.isFavorite,
    required this.onToggle,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: EdgeInsets.all(context.spacing.xs),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : context.colors.textSecondary,
          size: 18,
        ),
      ),
    );
  }
}

class _RatingWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  
  const _RatingWidget({
    required this.rating,
    required this.reviewCount,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          size: 14,
          color: Colors.amber,
        ),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyles.caption(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          '($reviewCount)',
          style: TextStyles.caption(context),
        ),
      ],
    );
  }
}

class _PriceWidget extends StatelessWidget {
  final Product product;
  
  const _PriceWidget({required this.product});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (product.isOnSale) ...[
          Text(
            '\$${product.listPrice.toStringAsFixed(2)}',
            style: TextStyles.caption(context).copyWith(
              decoration: TextDecoration.lineThrough,
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(width: context.spacing.xs),
        ],
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5, 
            children: [
              Image.asset('assets/icons/SAR.png' , width: 18, height: 16,   color: product.isOnSale 
                      ? context.colors.error 
                      : context.colors.primary,),
              Text(
                '${product.effectivePrice.toStringAsFixed(2)}',
                style: TextStyles.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: product.isOnSale 
                      ? context.colors.error 
                      : context.colors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}