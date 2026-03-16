import 'dart:async';
import 'package:echoemaar_commerce/features/products/data/datasources/product_local_datasource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/search_products.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProducts searchProducts;
  final ProductLocalDataSource searchHistory;

  Timer? _debounceTimer;

  SearchBloc({
    required this.searchProducts,
    required this.searchHistory,
  }) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<LoadSearchHistory>(_onLoadHistory);
    on<RemoveFromHistory>(_onRemoveFromHistory);
    on<ClearSearchHistory>(_onClearHistory);
    on<ApplyFilters>(_onApplyFilters);
    on<ClearFilters>(_onClearFilters);
  }

  // ── Query Changed (with debounce) ──────────────────────────────

  void _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    _debounceTimer?.cancel();

    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Show loading while typing
    emit(SearchLoading(query: event.query));

    // Debounce search
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      add(SearchSubmitted(event.query));
    });
  }

  // ── Search Submitted ───────────────────────────────────────────

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) return;

    emit(SearchLoading(query: event.query));

    // Save to history
    await searchHistory.addSearchQuery(event.query);

    // Get current filters
    String? colorFilter;
    double? minPrice;
    double? maxPrice;
    int? categoryId;

    if (state is SearchLoaded) {
      final current = state as SearchLoaded;
      colorFilter = current.colorFilter;
      minPrice = current.minPrice;
      maxPrice = current.maxPrice;
      categoryId = current.categoryId;
    }

    // Search
    final result = await searchProducts(SearchProductsParams(
      query: event.query,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
    ));

    result.fold(
      (failure) => emit(SearchError(failure.message, query: event.query)),
      (products) {
        // Filter by color if needed
        final filteredProducts = colorFilter != null
            ? products.where((p) => _matchesColor(p, colorFilter??'')).toList()
            : products;

        emit(SearchLoaded(
          query: event.query,
          products: filteredProducts,
          colorFilter: colorFilter,
          minPrice: minPrice,
          maxPrice: maxPrice,
          categoryId: categoryId,
        ));
      },
    );
  }

  // ── Load Search History ────────────────────────────────────────

  Future<void> _onLoadHistory(
    LoadSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    final history = await searchHistory.getSearchHistory();
    emit(SearchHistoryLoaded(history));
  }

  // ── Remove from History ────────────────────────────────────────

  Future<void> _onRemoveFromHistory(
    RemoveFromHistory event,
    Emitter<SearchState> emit,
  ) async {
    await searchHistory.removeSearchQuery(event.query);
    add(LoadSearchHistory());
  }

  // ── Clear History ──────────────────────────────────────────────

  Future<void> _onClearHistory(
    ClearSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    await searchHistory.clearSearchHistory();
    emit(const SearchHistoryLoaded([]));
  }

  // ── Apply Filters ──────────────────────────────────────────────

  void _onApplyFilters(
    ApplyFilters event,
    Emitter<SearchState> emit,
  ) {
    if (state is SearchLoaded) {
      final current = state as SearchLoaded;
      add(SearchSubmitted(current.query));
    }
  }

  // ── Clear Filters ──────────────────────────────────────────────

  void _onClearFilters(
    ClearFilters event,
    Emitter<SearchState> emit,
  ) {
    if (state is SearchLoaded) {
      final current = state as SearchLoaded;
      emit(current.copyWith(
        colorFilter: null,
        minPrice: null,
        maxPrice: null,
        categoryId: null,
      ));
      add(SearchSubmitted(current.query));
    }
  }

  // ── Helper: Color Matching ─────────────────────────────────────

  bool _matchesColor(Product product, String colorFilter) {
    final color = colorFilter.toLowerCase();
    
    // Check product name
    if (product.name.toLowerCase().contains(color)) return true;
    
    // Check variants
    // if (product.variants != null) {
    //   for (final variant in product.variants!) {
    //     if (variant.name.toLowerCase().contains(color)) return true;
    //   }
    // }
    
    return false;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
