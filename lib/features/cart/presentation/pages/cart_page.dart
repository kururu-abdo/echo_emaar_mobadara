// ═══════════════════════════════════════════════════════════════════
// FILE: features/cart/presentation/pages/cart_page.dart
// ═══════════════════════════════════════════════════════════════════

import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/cart_empty_widget.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {



  @override
  void initState() {
    super.initState();
    context.read<CartBloc>() 
    .add(LoadCartEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: context.colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Shopping Cart',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.cart.items!.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.delete_outline_rounded,
                      color: context.colors.error),
                  onPressed: () => _showClearCartDialog(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colors.success,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }

          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colors.error,
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<CartBloc>().add(LoadCartEvent());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded) {
            if (state.cart.isEmpty) {
              return const CartEmptyWidget();
            }

            return _CartContent(cart: state.cart, isSyncing: state.isSyncing);
          }

          if (state is CartError && state.currentCart != null) {
            // Show cart with error indicator
            return
            
    Text( 'Error: ${state.message}', style: TextStyle(color: context.colors.error),);
            _CartContent(
              cart: state.currentCart!,
              isSyncing: false,
            );
          }

          // Fallback
          return const CartEmptyWidget();
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ctx.pop();
              context.read<CartBloc>().add(ClearCartEvent());
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Cart Content (Item List + Summary)
// ═══════════════════════════════════════════════════════════════════

class _CartContent extends StatelessWidget {
  final Cart cart;
  final bool isSyncing;

  const _CartContent({
    required this.cart,
    required this.isSyncing,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      children: [
        // Syncing indicator
        if (isSyncing)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.xs,
            ),
            color: context.colors.primary.withOpacity(.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(context.colors.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Syncing...',
                  style: TextStyle(
                    color: context.colors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        // Items count
        Container(
          width: double.infinity,
          padding: spacing.pagePadding(context).copyWith(
                top: spacing.md,
                bottom: spacing.sm,
              ),
          child: Text(
            '${cart.totalItems} ${cart.totalItems == 1 ? 'item' : 'items'}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),

        // Item list
        Expanded(
          child: ListView.separated(
            padding: spacing.pagePadding(context),
            itemCount: cart.items!.length,
            separatorBuilder: (_, __) => SizedBox(height: spacing.md),
            itemBuilder: (context, index) {
              final item = cart.items![index];
              return CartItemCard(item: item);
            },
          ),  
        ),

        // Summary + Checkout
        CartSummaryCard(cart: cart),
      ],
    );
  }
}