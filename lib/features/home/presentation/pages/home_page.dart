// ═══════════════════════════════════════════════════════════════════
// FILE: features/home/presentation/pages/home_page.dart
// ═══════════════════════════════════════════════════════════════════

import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/features/home/presentation/widgets/home_carousel.dart';
import 'package:echoemaar_commerce/features/home/presentation/widgets/theme_background.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/favorits/favorite_state.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/favorits/favorites_cubit.dart';
import 'package:echoemaar_commerce/features/products/presentation/pages/categories_page.dart';
import 'package:echoemaar_commerce/features/products/presentation/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../injection_container.dart' as di;
import '../../../products/domain/entities/category.dart';
import '../../../products/domain/entities/product.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<HomeBloc>()..add(LoadHomeDataEvent()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const _LoadingView();
            }

            if (state is HomeError) {
              return _ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<HomeBloc>().add(LoadHomeDataEvent()),
              );
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(RefreshHomeDataEvent());
                  // Wait for refresh to complete
                  await Future.delayed(const Duration(milliseconds: 800));
                },
                child: CustomScrollView(
                  slivers: [
                    // ── App Bar ────────────────────────────────────
                    _HomeAppBar(),

                    // ── Search Bar ─────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: spacing.pagePadding(context).copyWith(
                              top: spacing.sm,
                              bottom: spacing.md,
                            ),
                        child: _SearchButton(),
                      ),
                    ),



const SliverToBoxAdapter(
                        child: HeroCarousel()

                      ),
                    // ── Categories Carousel ────────────────────────
                    if (state.categories.isNotEmpty)
                      SliverToBoxAdapter(
                        child: _CategoriesSection(
                          categories: state.categories,
                        ),
                      ),

                    // ── Banner / Promo ─────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: spacing.pagePadding(context).copyWith(
                              top: spacing.md,
                              bottom: spacing.md,
                            ),
                        child: _PromoBanner(),
                      ),
                    ),

                    // ── Featured Products ──────────────────────────
                    if (state.featuredProducts.isNotEmpty)
                      _ProductSection(
                        title: '✨ Featured',
                        products: state.featuredProducts,
                        onSeeAll: () => context.pushNamed(
                          RouteNames.categoryProducts,
                          pathParameters: {'id': '0'},
                          extra: 'Featured Products',
                        ),
                      ),

                    // ── Most Sold ──────────────────────────────────
                    if (state.mostSoldProducts.isNotEmpty)
                      _ProductSection(
                        title: '🔥 Most Sold',
                        products: state.mostSoldProducts,
                        onSeeAll: () => context.pushNamed(
                          RouteNames.categoryProducts,
                          pathParameters: {'id': '0'},
                          extra: 'Best Sellers',
                        ),
                      ),

                    // ── Most Wanted ────────────────────────────────
                    if (state.mostWantedProducts.isNotEmpty)
                      _ProductSection(
                        title: '💎 Most Wanted',
                        products: state.mostWantedProducts,
                        onSeeAll: () => context.pushNamed(
                          RouteNames.categoryProducts,
                          pathParameters: {'id': '0'},
                          extra: 'Trending Now',
                        ),
                      ),

                    // ── Bottom Padding ─────────────────────────────
                    SliverToBoxAdapter(
                      child: SizedBox(height: spacing.xxl),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Loading View
// ═══════════════════════════════════════════════════════════════════

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),
        SliverToBoxAdapter(
          child: Padding(
            padding: spacing.pagePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header shimmer
                const _Shimmer(width: 120, height: 28),
                spacing.verticalSM,
                const _Shimmer(width: 200, height: 16),
                spacing.verticalLG,

                // Search bar shimmer
                const _Shimmer(width: double.infinity, height: 48),
                spacing.verticalLG,

                // Category chips shimmer
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      5,
                      (i) => Padding(
                        padding: EdgeInsets.only(right: spacing.sm),
                        child: const _Shimmer(width: 100, height: 80),
                      ),
                    ),
                  ),
                ),
                spacing.verticalXL,

                // Product grid shimmer
                ...List.generate(3, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Shimmer(width: 150, height: 24),
                      spacing.verticalMD,
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: spacing.sm),
                          itemBuilder: (_, __) =>
                              const _Shimmer(width: 160, height: 220),
                        ),
                      ),
                      spacing.verticalXL,
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double width;
  final double height;

  const _Shimmer({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(context.shapes.borderRadiusSmall),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Error View
// ═══════════════════════════════════════════════════════════════════


class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 64, color: colors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// App Bar
// ═══════════════════════════════════════════════════════════════════

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return SliverToBoxAdapter(
      child: Container(
        padding: spacing.pagePadding(context).copyWith(
              top: spacing.md,
              bottom: spacing.md,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Greeting
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home.hello'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'home.what_looking_for'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                ),
              ],
            ),

            // Notification bell
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: colors.textPrimary,
                    size: 22,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Search Button
// ═══════════════════════════════════════════════════════════════════

class _SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return GestureDetector(
      onTap: () {
        // Navigate to search page or open search bottom sheet
        context.pushNamed(RouteNames.search);
      },
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: colors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'home.search_products'.tr(),
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(.1),
                borderRadius:
                    BorderRadius.circular(shapes.borderRadiusSmall),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: colors.primary,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Categories Section
// ═══════════════════════════════════════════════════════════════════

class _CategoriesSection extends StatelessWidget {
  final List<Category> categories;

  const _CategoriesSection({required this.categories});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: spacing.pagePadding(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home.categories'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all categories
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const CategoriesPage()));
                  
                },
                child:  Text('common.see_all'.tr()),
              ),
            ],
          ),
        ),
        spacing.verticalSM,
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: spacing.pagePadding(context),
            itemCount: categories.take(10).length,
            separatorBuilder: (_, __) => SizedBox(width: spacing.md),
            itemBuilder: (context, i) {
              final category = categories[i];
              return _CategoryCard(category: category);
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouteNames.categoryProducts,
          pathParameters: {'id': category.id.toString()},
          extra: category.name,
        );
      },
      child:
     

    SizedBox( 
      width: 80, 
      child:
      
      
     ThemeBackground(
      child: 
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image or icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(.1),
                shape: BoxShape.circle,
              ),
              child:
           
           
                  
                  CachedNetworkImage( 
imageUrl:
category.imageUrl??'' 
// "https://echomemaar.com/web/image/product.public.category/${category.id}/image_128"
,

fit: BoxFit.cover,
color:  const Color(0xFFe8f1f8),
// color: Theme.of(context).primaryColor,


                   )



// Image.network(category.imageUrl , )


            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600 , color: Colors.white),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
     )
    )
    
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Promo Banner
// ═══════════════════════════════════════════════════════════════════

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return Container(
      height: 185,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SPECIAL OFFER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get 50% Off\nYour First Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Shop Now'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_offer_rounded,
                color: Colors.white, size: 48),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Product Section (Featured / Most Sold / Most Wanted)
// ═══════════════════════════════════════════════════════════════════

class _ProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;
  final VoidCallback onSeeAll;

  const _ProductSection({
    required this.title,
    required this.products,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: spacing.pagePadding(context).copyWith(top: spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextButton(
                  onPressed: onSeeAll,
                  child:  Text('common.see_all'.tr()),
                ),
              ],
            ),
          ),
          spacing.verticalSM,
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: spacing.pagePadding(context),
              itemCount: products.take(10).length,
              separatorBuilder: (_, __) => SizedBox(width: spacing.sm),
              itemBuilder: (context, i) {
                final product = products[i];
                return SizedBox(
                  width: 160,
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (ctx, favState) => ProductGridItem(
                      product: product,
                      isFavorite: favState.isFavorite(product.id),
                      onTap: () {
                          Navigator.pushNamed(context,RouteNames.productDetail, 
                          
                          arguments: product.id, // Just pass the integer directly.
                          
                          ); // or context.pushNamed('details', pathParameters: {'id': '123'}) if using named routes
                      //   context.goNamed(
                      //   RouteNames.productDetail,
                      //   // pathParameters: {'id': product.id.toString()},
                      //     pathParameters: {'id': product.id.toString()}, // Pass parameters by key
                      // );
                      },
                      onFavoriteToggle: () =>
                          ctx.read<FavoritesCubit>().toggle(product.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}