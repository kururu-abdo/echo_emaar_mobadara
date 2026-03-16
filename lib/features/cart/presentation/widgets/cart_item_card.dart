import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
            child: Container(
              width: 80,
              height: 80,
              color: colors.surfaceVariant,
              child: item.image != null
                  ? CachedNetworkImage(
                      imageUrl: item.image!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.image_not_supported_outlined,
                        color: colors.textSecondary,
                      ),
                    )
                  : Icon(
                      Icons.shopping_bag_outlined,
                      color: colors.textSecondary,
                      size: 32,
                    ),
            ),
          ),

          SizedBox(width: spacing.md),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  item.productName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Price
                Row(
                  children: [

                    
                   Directionality(
              textDirection: TextDirection.ltr,
                      child: Row(
                         mainAxisSize: MainAxisSize.min,
                                  spacing: 2,
                        children: [
                                         Image.asset('assets/icons/SAR.png' , width: 14, height: 14,                                    color: colors.primary,
),

                          Text(
                            item.priceUnit.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colors.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    
                    
                    const SizedBox(width: 4),
                    Text(
                      'x ${item.quantity}',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Quantity Controls + Remove
                Row(
                  children: [
                    _QuantityControls(item: item),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _showRemoveDialog(context, item),
                      icon: Icon(Icons.delete_outline_rounded,
                          color: colors.error, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, CartItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove ${item.productName} from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // CRITICAL FIX: Use productId, not lineId
              log('🗑️ Removing item: productId=${item.productId}, lineId=${item.lineId}');
              context.read<CartBloc>().add(
                RemoveCartItemEvent(item.productId.toString()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colors.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Quantity Controls
// ═══════════════════════════════════════════════════════════════════

class _QuantityControls extends StatelessWidget {
  final CartItem item;

  const _QuantityControls({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease
          _QuantityButton(
            icon: Icons.remove,
            enabled: item.quantity > 1,
            onTap: () {
              final newQuantity = (item.quantity - 1).toInt();
              log('➖ Decrease: productId=${item.productId}, ${item.quantity} -> $newQuantity');
              
              context.read<CartBloc>().add(UpdateCartItemQuantityEvent(
                itemId: item.productId.toString(),
                quantity: newQuantity,
              ));
            },
          ),

          // Quantity
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${item.quantity}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: colors.textPrimary,
              ),
            ),
          ),

          // Increase
          _QuantityButton(
            icon: Icons.add,
            enabled: true,
            onTap: () {
              final newQuantity = (item.quantity + 1).toInt();
              log('➕ Increase: productId=${item.productId}, ${item.quantity} -> $newQuantity');
              
              context.read<CartBloc>().add(UpdateCartItemQuantityEvent(
                itemId: item.productId.toString(),
                quantity: newQuantity,
              ));
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? colors.textPrimary : colors.textSecondary,
        ),
      ),
    );
  }
}