import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';
import '../../../cart/domain/entities/cart.dart';

class OrderSummarySection extends StatelessWidget {
  final Cart cart;
  final double shippingFee;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;

  const OrderSummarySection({
    super.key,
    required this.cart,
    required this.shippingFee,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          // Items count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items (${cart.totalItems})',
                style: TextStyle(color: colors.textSecondary),
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Shipping
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping', style: TextStyle(color: colors.textSecondary)),
              Text(
                shippingFee == 0
                    ? 'FREE'
                    : '\$${shippingFee.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: shippingFee == 0 ? colors.success : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tax
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax', style: TextStyle(color: colors.textSecondary)),
              Text(
                '\$${tax.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          // Discount (if any)
          if (discount > 0) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount', style: TextStyle(color: colors.textSecondary)),
                Text(
                  '-\$${discount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colors.success,
                  ),
                ),
              ],
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
