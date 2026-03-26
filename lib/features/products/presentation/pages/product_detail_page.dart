
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/widgets/custom_button.dart';
import 'package:echoemaar_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/favorits/favorite_state.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/favorits/favorites_cubit.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:echoemaar_commerce/features/products/presentation/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mtrl;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/product.dart';


class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ProductDetailBloc>()
        ..add(LoadProductDetailEvent(productId)),
      child: const _ProductDetailView(),
    );
  }
}



class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ProductDetailError) {
          return _DetailErrorScaffold(message: state.message);
        }
        if (state is ProductDetailLoaded) {
          return _LoadedDetail(state: state);
        }
        return const Scaffold();
      },
    );
  }
}

// ── Loaded Detail ─────────────────────────────────────────────────


// import 'widgets/app_button.dart'; // The scaling button with primary gradient

class _LoadedDetail extends StatelessWidget {
  final ProductDetailLoaded state;
  const _LoadedDetail({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final product = state.product;
    final spacing = context.spacing;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: true,
        top: false,
        child: CustomScrollView(
          slivers: [
            // ── Immersive Header ──────────────────────────────
            SliverAppBar(
              expandedHeight: 450, // Larger hero area as seen in design
              pinned: true,
              stretch: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              title:  Text('products.product_details'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _ImageGallery(images: [product.imageUrl ?? '']),
                    // Dark gradient overlay for text readability
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black38, Colors.transparent, Colors.black45],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        const SliverToBoxAdapter(
          child:   Column(
            children: [
              
        
            ],
          )
        
        ),
            // ── Content Panel ──────────────────────────────────
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -30), // Pulls the card up over the image
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Favorite Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          _buildFavoriteButton(context, product.id),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      _buildRatingRow(context, 4.5, 468), // Placeholder ratings
                      
                      const Divider(height: 40),
        
                      const _SectionLabel(label: 'Description'),
                      const SizedBox(height: 12),
                      _ExpandableDescription(description: product.name), // Replace with actual description field
        
                      const SizedBox(height: 24),
                      const _SectionLabel(label: 'Select Color : Black'),
                      const SizedBox(height: 12),
                      // _buildColorSelector(context),
                      _SectionLabel(label: 'Quantity'),
                    spacing.verticalSM,
                    _QuantitySelector(
                      quantity: state.quantity,
                      maxStock: product.qtyAvailable,
                      // maxStock: state.selectedVariant?.stock ?? product.stock,
                      onChanged: (q) {
                        log(q.toString());
                        context
                          .read<ProductDetailBloc>()
                          .add(UpdateQuantityEvent(q));

                      },
                    ),
        
        
                      const SizedBox(height: 32),
                      const _SectionLabel(label: 'Related Products'),
                      const SizedBox(height: 16),
                      _RelatedProducts(
                        products: state.relatedProducts,
                        onProductTap: (id) => context.pushNamed('/product-detail/$id'),
                      ),
                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ),


          
          ],
        ),
      ),
      bottomNavigationBar: _BottomActions(state: state),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, int id) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.border),
      ),
      child: IconButton(
        icon:  Icon(
           context.read<FavoritesCubit>().isFavorite(id)? Icons.favorite:
          Icons.favorite_border_rounded, size: 22),
          color:context.read<FavoritesCubit>().isFavorite(id)?Colors.red: null,
        onPressed: () {

          context.read<FavoritesCubit>().toggle(id);
        }, // Cubit toggle logic
      ),
    );
  }

  Widget _buildRatingRow(BuildContext context, double rating, int reviews) {
    return Row(
      children: [
        ...List.generate(4, (i) => const Icon(Icons.star_rounded, color: Colors.amber, size: 20)),
        const Icon(Icons.star_half_rounded, color: Colors.amber, size: 20),
        const SizedBox(width: 8),
        Text('($reviews Reviews)', style: TextStyle(color: context.colors.textSecondary)),
      ],
    );
  }

  Widget _buildColorSelector(BuildContext context) {
    final colors = [const Color(0xFFD8C3C3), const Color(0xFFC7A17A), const Color(0xFFE5E5E5), Colors.black];
    return Row(
      children: colors.map((c) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: CircleAvatar(radius: 14, backgroundColor: c),
      )).toList(),
    );
  }
}
// ── Image Gallery ─────────────────────────────────────────────────

class _ImageGallery extends StatefulWidget {
  final List<String> images;

  const _ImageGallery({required this.images});

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final images =
        widget.images.isNotEmpty ? widget.images : <String>[];

    return Stack(
      children: [
        // Image slider
        PageView.builder(
          onPageChanged: (i) => setState(() => _current = i),
          itemCount: images.isEmpty ? 1 : images.length,
          itemBuilder: (_, i) {
            if (images.isEmpty) {
              return Container(
                color: context.colors.surfaceVariant,
                child: Icon(Icons.image_not_supported_outlined,
                    size: 64, color: context.colors.textSecondary),
              );
            }
            return CachedNetworkImage(
              imageUrl: images[i],
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                  color: context.colors.surfaceVariant),
              errorWidget: (_, __, ___) => Container(
                color: context.colors.surfaceVariant,
                child: Icon(Icons.broken_image_outlined,
                    color: context.colors.textSecondary),
              ),
            );
          },
        ),

        // Page dots
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _current ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _current
                        ? Colors.white
                        : Colors.white.withOpacity(.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Variant Selector ──────────────────────────────────────────────
/*
class _VariantSelector extends StatelessWidget {
  final List<ProductVariant> variants;
  final ProductVariant? selected;
  final ValueChanged<ProductVariant> onSelect;

  const _VariantSelector({
    required this.variants,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: variants.map((v) {
        final isSelected = true;
        final isAvailable =true;

        return GestureDetector(
          onTap: isAvailable ? () => onSelect(v) : null,
          child: Opacity(
            opacity: isAvailable ? 1 : 0.4,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary
                    : colors.surfaceVariant,
                borderRadius:
                    BorderRadius.circular(shapes.borderRadiusSmall),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.border,
                  width: 1.5,
                ),
              ),
              child: Text(
                v.name.split(' ').last, // e.g. "Red", "XL"
                style: TextStyle(
                  color: isSelected ? Colors.white : colors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
*/
// ── Quantity Selector ─────────────────────────────────────────────

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxStock;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({
    required this.quantity,
    required this.maxStock,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return Row(
      children: [
        _QtyButton(
          icon: Icons.remove,
          enabled: quantity > 1,
          onTap: () => onChanged(quantity - 1),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(.1),
            borderRadius:
                BorderRadius.circular(shapes.borderRadiusSmall),
          ),
          child: Text(
            '$quantity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
        ),
        _QtyButton(
          icon: Icons.add,
          enabled: quantity < maxStock,
          onTap: () => onChanged(quantity + 1),
        ),
        const SizedBox(width: 12),
        Text(
          '$maxStock in stock',
          style: TextStyle(
              color: colors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? colors.primary : colors.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            size: 18,
            color: enabled ? Colors.white : colors.textSecondary),
      ),
    );
  }
}

// ── Expandable Description ────────────────────────────────────────

class _ExpandableDescription extends StatefulWidget {
  final String description;

  const _ExpandableDescription({required this.description});

  @override
  State<_ExpandableDescription> createState() =>
      _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLong = widget.description.length > 200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: Text(
            widget.description.isEmpty
                ? 'No description available.'
                : widget.description,
            maxLines: _expanded ? null : 4,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: colors.textSecondary, height: 1.6),
          ),
        ),
        if (isLong) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Show less' : 'Read more',
              style: TextStyle(
                  color: colors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Stock Row ─────────────────────────────────────────────────────

class _StockRow extends StatelessWidget {
  final Product product;

  const _StockRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isIn = product.qtyAvailable>0;

    return Row(
      children: [
        Icon(
          isIn ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: isIn ? colors.success : colors.error,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          isIn
              ? product.qtyAvailable < 5
                  ? 'Only ${product.qtyAvailable} left!'
                  : 'In Stock'
              : 'Out of Stock',
          style: TextStyle(
            color: isIn
                ? product.qtyAvailable < 5
                    ? colors.warning
                    : colors.success
                : colors.error,
            fontWeight: FontWeight.w600,
          ),
        ),

        /*
        if (product.sku != null) ...[
          const SizedBox(width: 16),
          Text('SKU: ${product.sku}',
              style: TextStyle(
                  color: colors.textSecondary, fontSize: 12)),

                
        ],

        */
      ],
    );
  }
}

// ── Related Products ─────────────────────────────────────────────

class _RelatedProducts extends StatelessWidget {
  final List<Product> products;
  final void Function(int id) onProductTap;

  const _RelatedProducts({
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final p = products[i];
          return SizedBox(
            width: 160,
            child: BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (ctx, favState) => ProductGridItem(
                product: p,
                isFavorite: favState.isFavorite(p.id),
                onTap: () => onProductTap(p.id),
                onFavoriteToggle: () =>
                    ctx.read<FavoritesCubit>().toggle(p.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Bottom Actions ────────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  final ProductDetailLoaded state;
  const _BottomActions({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = state.effectivePrice * state.quantity;
final canBuy = state.product.qtyAvailable > 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          // Total Price Label
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Price', style: TextStyle(color: colors.textSecondary, fontSize: 14)),
              Text(
                '${total.toStringAsFixed(0)} ر.س',
                style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 32),
          // Scaling Primary Button
          Expanded(
            child: AppButton(
              label: 'Add To Cart',
              icon: Icons.shopping_bag_outlined,
              onTap: 
             canBuy
                  ? () {
                      context.read<CartBloc>().add(AddToCartEvent(
                            productId: state.product.id,
                            variantId: state.product.id,
                            quantity: state.quantity, productName:state.product.name, unitPrice: state.product.listPrice,
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:  Text(context.tr('added_to_cart')),
                          backgroundColor: colors.success,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  : null,
              
            ),
          ),
        ],
      ),
    );
  }
}
// ── Helpers ───────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Pill({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _DetailErrorScaffold extends StatelessWidget {
  final String message;

  const _DetailErrorScaffold({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: context.colors.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}


