/*

// ─────────────────────────────────────────────────────────────────
// FILE: features/products/presentation/pages/category_products_page.dart
// ─────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../bloc/favorites/favorites_cubit.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/product_grid_shimmer.dart';

class CategoryProductsPage extends StatefulWidget {
  final int categoryId;
  final String? categoryName;

  const CategoryProductsPage({
    super.key,
    required this.categoryId,
    this.categoryName,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  final _scrollCtrl = ScrollController();

  SortOption? _sortOption;
  double? _minPrice;
  double? _maxPrice;
  bool _inStockOnly = false;
  int _filterCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    _load();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _load() {
    context.read<ProductListBloc>().add(LoadProductsEvent(
          categoryId: widget.categoryId,
          sortBy: _sortString,
        ));
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      final s = context.read<ProductListBloc>().state;
      if (s is ProductListLoaded && !s.hasReachedMax) {
        context.read<ProductListBloc>().add(LoadMoreProductsEvent(
              categoryId: widget.categoryId,
              sortBy: _sortString,
            ));
      }
    }
  }

  String? get _sortString {
    switch (_sortOption) {
      case SortOption.priceLowToHigh:
        return 'list_price asc';
      case SortOption.priceHighToLow:
        return 'list_price desc';
      case SortOption.rating:
        return 'rating_avg desc';
      case SortOption.popularity:
        return 'sales_count desc';
      default:
        return 'id desc';
    }
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, sc) => FilterBottomSheet(
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          sortOption: _sortOption,
          inStockOnly: _inStockOnly,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      _minPrice = result['minPrice'];
      _maxPrice = result['maxPrice'];
      _sortOption = result['sortOption'];
      _inStockOnly = result['inStockOnly'] ?? false;
      _filterCount = [
        _sortOption != null,
        (_minPrice ?? 0) > 0,
        (_maxPrice ?? 1000) < 1000,
        _inStockOnly,
      ].where((b) => b).length;
    });

    context.read<ProductListBloc>().add(FilterProductsEvent(
          categoryId: widget.categoryId,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          inStockOnly: _inStockOnly,
          sortBy: _sortString,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.categoryName ?? 'Products',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.tune_rounded, color: colors.textPrimary),
                onPressed: _openFilters,
              ),
              if (_filterCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: colors.error, shape: BoxShape.circle),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$_filterCount',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ProductListBloc, ProductListState>(
        builder: (context, state) {
          if (state is ProductListLoading) {
            return const ProductGridShimmer();
          }
          if (state is ProductListError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off_rounded,
                      size: 48, color: colors.textSecondary),
                  const SizedBox(height: 12),
                  Text(state.message,
                      style: TextStyle(color: colors.textSecondary)),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: _load, child: const Text('Retry')),
                ],
              ),
            );
          }
          if (state is ProductListLoaded) {
            if (state.products.isEmpty) {
              return EmptyProductsWidget(
                onClearSearch: _load,
              );
            }

            final columns = ResponsiveUtils.getGridColumns(context);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductListBloc>().add(RefreshProductsEvent());
              },
              child: GridView.builder(
                controller: _scrollCtrl,
                padding: spacing.pagePadding(context),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: spacing.sm,
                  mainAxisSpacing: spacing.sm,
                  childAspectRatio: 0.68,
                ),
                itemCount: state.products.length +
                    (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, i) {
                  if (i >= state.products.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  final product = state.products[i];

                  return BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (ctx, favState) => ProductGridItem(
                      product: product,
                      isFavorite: favState.isFavorite(product.id),
                      onTap: () => context.pushNamed(
                        RouteNames.productDetail,
                        pathParameters: {'id': product.id.toString()},
                      ),
                      onFavoriteToggle: () =>
                          ctx.read<FavoritesCubit>().toggle(product.id),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// FILE: injection_container.dart  — products section (COMPLETE)
// ─────────────────────────────────────────────────────────────────

/*
Add this to your injection_container.dart init() function:

  _initProducts();

Then add the method:
*/

void _initProducts() {
  // ── Data sources ──────────────────────────────────────────────
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(odooClient: sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );

  // ── Repository ────────────────────────────────────────────────
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ── Use cases ─────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductDetails(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetCategoryById(sl()));
  sl.registerLazySingleton(() => GetFeaturedProducts(sl()));
  sl.registerLazySingleton(() => GetRelatedProducts(sl()));
  sl.registerLazySingleton(() => GetProductVariants(sl()));

  // ── BLoCs / Cubits ────────────────────────────────────────────
  sl.registerFactory(
    () => ProductListBloc(
      getProducts: sl(),
      searchProducts: sl(),
    ),
  );

  sl.registerFactory(
    () => ProductDetailBloc(
      getProductDetails: sl(),
      getRelatedProducts: sl(),
      getProductVariants: sl(),
    ),
  );

  // Favorites uses SharedPreferences — registered as singleton
  sl.registerLazySingleton(
    () => FavoritesCubit(sl<SharedPreferences>()),
  );
}

// ─────────────────────────────────────────────────────────────────
// FILE: app.dart  — wrap with products BLoC providers
// ─────────────────────────────────────────────────────────────────

/*
Inside MultiBlocProvider add:

  BlocProvider<ProductListBloc>(
    create: (_) => sl<ProductListBloc>(),
  ),
  BlocProvider<FavoritesCubit>(
    create: (_) => sl<FavoritesCubit>(),
  ),
*/

// ─────────────────────────────────────────────────────────────────
// FILE: config/routes/app_router.dart  — product routes (already in GoRouter doc)
// Ensure these routes exist:
// ─────────────────────────────────────────────────────────────────

/*
GoRoute(
  path: '/product/:id',
  name: RouteNames.productDetail,
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return ProductDetailPage(productId: id);
  },
),

GoRoute(
  path: '/category/:id',
  name: RouteNames.categoryProducts,
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    final name = state.extra as String?;
    return BlocProvider(
      create: (_) => sl<ProductListBloc>(),
      child: CategoryProductsPage(categoryId: id, categoryName: name),
    );
  },
),


*/


*/