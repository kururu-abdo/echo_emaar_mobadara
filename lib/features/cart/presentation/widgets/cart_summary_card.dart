import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/cart.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../config/routes/route_names.dart';

class CartSummaryCard extends StatelessWidget {
  final Cart cart;

  const CartSummaryCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final shapes = context.shapes;

    return Container(
      padding: spacing.pagePadding(context).copyWith(
            top: spacing.md,
            bottom: spacing.md + MediaQuery.of(context).padding.bottom,
          ),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtotal
          _SummaryRow(
            label: 'Subtotal',
            value: '${cart.subtotal!.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          // Tax
          _SummaryRow(
            label: 'Tax',
            value: '${cart.tax!.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          // Discount
          if (cart.discount! > 0) ...[
            _SummaryRow(
              label: 'Discount',
              value: '-${cart.discount!.toStringAsFixed(2)}',
              valueColor: colors.success,
            ),
            const SizedBox(height: 8),
          ],

          // Shipping
          if (cart.shippingFee! > 0) ...[
            _SummaryRow(
              label: 'Shipping',
              value: '${cart.shippingFee!.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
          ],

          Divider(color: colors.divider),

          const SizedBox(height: 8),

          // Total
          _SummaryRow(
            label: 'Total',
            value: '${cart.total!.toStringAsFixed(2)}',
            isBold: true,
            valueSize: 20,
          ),

          const SizedBox(height: 16),

          // Checkout Button
         BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
              return AppButton(label: 'to checkout' , icon: Icons.arrow_forward, 
              onTap: ()async{
                if (authState is Authenticated) {
                          // Go to checkout
                          Navigator.pushNamed(context, RouteNames.checkout);
                        } else {
                          // Go to login
                           Navigator.pushNamed(context, RouteNames.login);
                        }
              },
              
              
              );
            }
          ) ,
/*
          SizedBox(
            width: double.infinity,
            height: 52,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return FilledButton(
                  onPressed: () {
                    if (authState is Authenticated) {
                      // Go to checkout
                      Navigator.pushNamed(context, RouteNames.checkout);
                    } else {
                      // Go to login
                       Navigator.pushNamed(context, RouteNames.login);
                    }
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(shapes.borderRadiusSmall),
                    ),
                  ),
                  child: Text(
                    authState is Authenticated
                        ? 'Proceed to Checkout'
                        : 'Login to Checkout',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ),

          */

          // Guest indicator
          if (cart.isGuest!) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 14, color: colors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Cart is stored locally',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final double? valueSize;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueSize,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      Directionality(
              textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [

               Image.asset('assets/icons/SAR.png' , width: 14, height: 14,   color: valueColor ?? colors.textPrimary,),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? colors.textPrimary,
                  fontSize: valueSize ?? 14,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}