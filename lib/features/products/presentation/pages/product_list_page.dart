

// ─────────────────────────────────────────────────────────────────
// FILE: features/products/presentation/pages/product_list_page.dart
// ─────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/core/utilities/orientation_utils.dart';
import 'package:echoemaar_commerce/core/utilities/responsive_utils.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/favorits/favorite_state.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/favorits/favorites_cubit.dart';
import 'package:echoemaar_commerce/features/products/presentation/widgets/all_products_shimmer.dart';
import 'package:echoemaar_commerce/features/products/presentation/widgets/empty_product_state.dart';
import 'package:echoemaar_commerce/features/products/presentation/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../widgets/category_chip_list.dart';
import '../widgets/filter_bottom_sheet.dart';

import '../widgets/search_bar_widget.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // ── Controllers ──────────────────────────────────────────────────
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Timer? _debounce;

  // ── Filter state ─────────────────────────────────────────────────
  int? _selectedCategoryId;
  String? _selectedCategoryName;
  double? _minPrice;
  double? _maxPrice;
  SortOption? _sortOption;
  bool _inStockOnly = false;
  double? _minRating;
  int _activeFilterCount = 0;

  // ── Categories ───────────────────────────────────────────────────
  final List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    // _scrollCtrl.addListener(_onScroll);
    // _loadCategories();
    WidgetsBinding.instance.addPostFrameCallback((_){

      _loadProducts();
    _loadMostSoldProducts();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Data loading ─────────────────────────────────────────────────

  void _loadProducts() {
    context.read<ProductListBloc>().add(LoadProductsEvent(
      context: context,
          // categoryId: _selectedCategoryId,
          // sortBy: _sortString,
        ));
  }
  void _loadMostSoldProducts() {
    context.read<ProductListBloc>().add(LoadMostSoldProductsEvent(
      context: context,
          // categoryId: _selectedCategoryId,
          // sortBy: _sortString,
        ));
  }


/*
  Future<void> _loadCategories() async {
    final result = await di.sl<GetCategories>().call(NoParams());
    result.fold((_) {}, (cats) => setState(() => _categories = cats));
  }


  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      final state = context.read<ProductListBloc>().state;
      if (state is ProductListLoaded && !state.hasReachedMax) {
        context.read<ProductListBloc>().add(LoadMoreProductsEvent(
              categoryId: _selectedCategoryId,
              sortBy: _sortString,
            ));
      }
    }
  }
  */


  // ── Search ───────────────────────────────────────────────────────

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.isEmpty) {
      _loadProducts();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // context.read<ProductListBloc>().add(SearchProductsEvent(query));
    });
  }

  // ── Category ─────────────────────────────────────────────────────

  void _onCategorySelected(int? id) {
    setState(() {
      _selectedCategoryId = id;
      _selectedCategoryName =
          id == null ? null : _categories.firstWhere((c) => c.id == id).name;
    });
    _loadProducts();
  }

  // ── Filter sheet ─────────────────────────────────────────────────

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
          minRating: _minRating,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      _minPrice = result['minPrice'] as double?;
      _maxPrice = result['maxPrice'] as double?;
      _sortOption = result['sortOption'] as SortOption?;
      _inStockOnly = result['inStockOnly'] as bool? ?? false;
      _minRating = result['minRating'] as double?;

      _activeFilterCount = [
        _sortOption != null,
        (_minPrice ?? 0) > 0,
        (_maxPrice ?? 1000) < 1000,
        _inStockOnly,
        (_minRating ?? 0) > 0,
      ].where((b) => b).length;
    });
/*
    context.read<ProductListBloc>().add(FilterProductsEvent(
          categoryId: _selectedCategoryId,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          inStockOnly: _inStockOnly,
          minRating: _minRating,
          sortBy: _sortString,
        ));

        */
  }

  // ── Helpers ───────────────────────────────────────────────────────

  String? get _sortString {
    switch (_sortOption) {
      case SortOption.priceLowToHigh:
        return 'list_price asc';
      case SortOption.priceHighToLow:
        return 'list_price desc';
      case SortOption.popularity:
        return 'sales_count desc';
      case SortOption.rating:
        return 'rating_avg desc';
      case SortOption.newest:
      case null:
        return 'id desc';
    }
  }

  // ── Build ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // ── Search bar ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.sm,
            ),
            child: SearchBarWidget(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              onFilterTap: _openFilters,
              filterCount: _activeFilterCount,
            ),
          ),

          // ── Category chips ──────────────────────────────────────
          if (_categories.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: CategoryChipList(
                categories: _categories,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: _onCategorySelected,
              ),
            ),

          // ── Results header ──────────────────────────────────────
        
      
          BlocBuilder<ProductListBloc, ProductListState>(
            buildWhen: (p, c) => c is ProductListLoaded,
            builder: (context, state) {
              if (state is! ProductListLoaded) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.xs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategoryName != null
                          ? _selectedCategoryName!
                          : 'All Products',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    Text(
                      '${state.products.length} items',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              );
            },
          ),

          // ── Grid ────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                if (state is ProductListLoading) {
                  return
                  
                  const AllProductsShimmer();
                  //  const ProductGridShimmer();
                }
                if (state is ProductListError) {
                  return _ErrorView(
                    message: state.message,
                    onRetry: _loadProducts,
                  );
                }
                if (state is ProductListLoaded) {
                  if (state.products.isEmpty) {
                    return EmptyProductsWidget(
                      searchQuery: _searchCtrl.text,
                      // onClearSearch: () {
                      //   _searchCtrl.clear();
                      //   _loadProducts();
                      // },
                    );
                  }
                  return _ProductGrid(
                    state: state,
                    scrollController: _scrollCtrl,
                    onProductTap: (id) =>
                        context.pushNamed(RouteNames.productDetail,
                            pathParameters: {'id': id.toString()}),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        
        
        
        
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colors = context.colors;
    return AppBar(
      backgroundColor: colors.surface,
      elevation: 0,
      title: Text(
        'Discover',
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.notifications_outlined, color: colors.textPrimary),
              Positioned(
                right: 0,
                top: 0,
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
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ── Extracted Grid Widget ─────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  final ProductListLoaded state;
  final ScrollController scrollController;
  final void Function(int id) onProductTap;

  const _ProductGrid({
    required this.state,
    required this.scrollController,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final columns = ResponsiveUtils.getGridColumns(context);

    return RefreshIndicator(
      onRefresh: () async {
        // context.read<ProductListBloc>().add(RefreshProductsEvent());
      },
      child: GridView.builder(
        controller: scrollController,
        padding: spacing.pagePadding(context),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.getOrientationValue(
            portrait: columns,
            landscape: columns + 1,
          ),
          crossAxisSpacing: spacing.sm,
          mainAxisSpacing: spacing.sm,
          childAspectRatio: 0.68,
        ),
        itemCount: state.products.length ,
        // + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, i) {
          // Pagination loader tile
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
            builder: (context, favState) {
              return ProductGridItem(
                product: product,
                isFavorite: favState.isFavorite(product.id),
                onTap: () => onProductTap(product.id),
                onFavoriteToggle: () =>
                    context.read<FavoritesCubit>().toggle(product.id),
              );
            },
          );
        },
      ),
    );
  }
}

// ── Error View ────────────────────────────────────────────────────

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
            Icon(Icons.wifi_off_rounded, size: 64, color: colors.textSecondary),
            const SizedBox(height: 16),
            Text('Oops! Something went wrong',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center),
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


