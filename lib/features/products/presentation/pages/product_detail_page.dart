
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
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

class _LoadedDetail extends StatelessWidget {
  final ProductDetailLoaded state;

  const _LoadedDetail({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final product = state.product;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          // ── Image gallery app bar ───────────────────────────
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: colors.surface,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: Colors.black87),
              ),
            ),
            actions: [
              // Favorite
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (ctx, favState) => GestureDetector(
                  onTap: () =>
                      ctx.read<FavoritesCubit>().toggle(product.id),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      favState.isFavorite(product.id)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: favState.isFavorite(product.id)
                          ? Colors.red
                          : Colors.black54,
                      size: 20,
                    ),
                  ),
                ),
              ),
              // Share
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_outlined,
                      size: 20, color: Colors.black54),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _ImageGallery(images: [product.imageUrl??'']),
            ),
          ),

          // ── Body ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: spacing.pagePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spacing.verticalMD,

                    // ── Category + badges row ─────────────────
                    Row(
                      children: [
                        _Pill(
                          label: product.category,
                          color: colors.primary.withOpacity(.1),
                          textColor: colors.primary,
                        ),
                        if (product.isOnSale) ...[
                          const SizedBox(width: 8),
                          _Pill(
                            label:
                                '-${product.discountPercentage.toStringAsFixed(0)}%',
                            color: colors.error,
                            textColor: Colors.white,
                          ),
                        ],
                        if (product.qtyAvailable < 5) ...[
                          const SizedBox(width: 8),
                          _Pill(
                            label: 'Low Stock',
                            color: colors.warning.withOpacity(.15),
                            textColor: colors.warning,
                          ),
                        ],
                      ],
                    ),

                    spacing.verticalSM,

                    // ── Name ──────────────────────────────────
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                    ),

                    spacing.verticalSM,
/*
                    // ── Rating row ────────────────────────────
                    if (product.rating != null)
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              i < product.rating!.floor()
                                  ? Icons.star_rounded
                                  : (i < product.rating!
                                      ? Icons.star_half_rounded
                                      : Icons.star_outline_rounded),
                              color: Colors.amber,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.rating!.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount} reviews)',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
*/
                    spacing.verticalMD,

                    // ── Price ─────────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Directionality(
                           textDirection: mtrl. TextDirection.ltr,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5,
                            children: [
                                Image.asset('assets/icons/SAR.png' , width: 18, height: 16,   color: product.isOnSale 
                      ? context.colors.error 
                      : context.colors.primary,),
                              Text(
                                '${state.effectivePrice.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: product.isOnSale
                                          ? colors.error
                                          : colors.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                     
                     
                        if (product.isOnSale) ...[
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child:Directionality(
                           textDirection: mtrl. TextDirection.ltr,
                              child: Stack(alignment: Alignment.center,
                                children: [
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                  spacing: 2,
                                    children: [
                                       Image.asset('assets/icons/SAR.png' , width: 18, height: 16,   color: product.isOnSale 
                                                        ?   colors.textSecondary
                                                        : context.colors.primary,),
                                      Text(
                                        '${product.listPrice.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              // decoration: TextDecoration.lineThrough,
                                              color: colors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),

                                  Positioned(
left: 0,right: 0,

                                    child: Container(height: 1, color: colors.textSecondary,))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
/*
                    spacing.verticalLG,

                    // ── Variants ──────────────────────────────
                    if (state.variants.isNotEmpty) ...[
                      _SectionLabel(label: 'Options'),
                      spacing.verticalSM,
                      _VariantSelector(
                        variants: state.variants,
                        selected: state.selectedVariant,
                        onSelect: (v) => context
                            .read<ProductDetailBloc>()
                            .add(SelectVariantEvent(v)),
                      ),
                      spacing.verticalLG,
                    ],
*/
                    // ── Quantity ──────────────────────────────
                    const _SectionLabel(label: 'Quantity'),
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

                    spacing.verticalLG,

                    // ── Description ───────────────────────────
                    const _SectionLabel(label: 'Description'),
                    spacing.verticalSM,
                    _ExpandableDescription(description: product.name),

                    // ── Stock info ────────────────────────────
                    spacing.verticalLG,
                    _StockRow(product: product),

                    // ── Related products ──────────────────────
                    if (state.relatedProducts.isNotEmpty) ...[
                      spacing.verticalXL,
                      const _SectionLabel(label: 'You may also like'),
                      spacing.verticalMD,
                      _RelatedProducts(
                        products: state.relatedProducts,
                        onProductTap: (id) => context.pushNamed(
                          RouteNames.productDetail,
                          pathParameters: {'id': id.toString()},
                        ),
                      ),
                    ],

                    spacing.verticalXXL,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Bottom action bar ─────────────────────────────────────
      bottomNavigationBar: _BottomActions(state: state),
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
    final spacing = context.spacing;
    final shapes = context.shapes;
    final canBuy = state.product.qtyAvailable > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.sm,
        spacing.md,
        spacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
              color: colors.shadow, blurRadius: 12, offset: const Offset(0, -4))
        ],
      ),
      child: Row(
        children: [
          // ── Add to Cart ────────────────────────────────────
          Expanded(
            child: OutlinedButton.icon(
              onPressed: canBuy
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
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Add to Cart'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(shapes.borderRadiusSmall),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ── Buy Now ────────────────────────────────────────
          Expanded(
            child: FilledButton(
              onPressed: canBuy
                  ? () {
                      context.read<CartBloc>().add(AddToCartEvent(
                            productId: state.product.id,
                            variantId: state.product.id,
                            quantity: state.quantity, productName: '', unitPrice: state.product.listPrice,
                          ));
                      context.pushNamed(RouteNames.checkout);
                    }
                  : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(shapes.borderRadiusSmall),
                ),
              ),
              child: Text(canBuy ? 'Buy Now' : 'Out of Stock'),
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


