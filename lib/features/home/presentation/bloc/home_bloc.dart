
// ═══════════════════════════════════════════════════════════════════
// FILE: features/home/presentation/bloc/home_bloc.dart
// ═══════════════════════════════════════════════════════════════════

import 'dart:developer';

import 'package:echoemaar_commerce/features/products/domain/usecases/get_featured_products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../products/domain/entities/category.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/usecases/get_categories.dart';
import '../../../products/domain/usecases/get_products.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategories getCategories;
  final GetProducts getProducts;
  final GetFeaturedProducts getFeaturedProducts;


  HomeBloc({
    required this.getCategories,
    required this.getProducts,
    required this.getFeaturedProducts,
  }) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoad);
    on<RefreshHomeDataEvent>(_onRefresh);

  }

  // ── Load (first time) ──────────────────────────────────────────────

  Future<void> _onLoad(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    await _fetchAndEmit(emit);
  }

  // ── Refresh (pull-to-refresh) ──────────────────────────────────────

  Future<void> _onRefresh(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Keep current state visible during refresh
    // Only emit loading if we're in error or initial state
    final current = state;
    if (current is! HomeLoaded) {
      emit(HomeLoading());
    }

    await _fetchAndEmit(emit);
  }

  // ── Shared fetch logic ─────────────────────────────────────────────

  Future<void> _fetchAndEmit(Emitter<HomeState> emit) async {
    try {
      // Fire all 4 requests in parallel
      final results = await Future.wait([
        getCategories(NoParams()),
        getFeaturedProducts(NoParams()),
        _getMostSold(),
        _getMostWanted(),
      ]);

      // Unpack results
      final categoriesResult = results[0];
      final featuredResult = results[1];
      final mostSoldResult = results[2];
      final mostWantedResult = results[3];

      // Check for failures
      String? error;

      final categories = categoriesResult.fold(
        (failure) {
          error ??= failure.message;
          return <Category>[];
        },
        (data) => data as List<Category>,
      );

      final featured = featuredResult.fold(
        (failure) {
          log('BIG FAILURE ${failure}');
          error ??= failure.message;
          return <Product>[];
        },
        (data) => data as List<Product>,
      );

      final mostSold = mostSoldResult.fold(
        (failure) {
          error ??= failure.message;
          return <Product>[];
        },
        (data) => data as List<Product>,
      );

      final mostWanted = mostWantedResult.fold(
        (failure) {
          error ??= failure.message;
          return <Product>[];
        },
        (data) => data as List<Product>,
      );

      // If we got at least some data, emit loaded state even if some failed
      if (categories.isNotEmpty ||
          featured.isNotEmpty ||
          mostSold.isNotEmpty ||
          mostWanted.isNotEmpty) {
        emit(HomeLoaded(
          categories: categories,
          featuredProducts: featured,
          mostSoldProducts: mostSold,
          mostWantedProducts: mostWanted,
        ));
      } else {
        // All requests failed
        emit(HomeError(error ?? 'Failed to load home data'));
      }
    } catch (e) {
      emit(HomeError('An unexpected error occurred: $e'));
    }
  }

  // ── Most Sold ──────────────────────────────────────────────────────
  //
  // In Odoo, "most sold" can be determined by:
  //   - sales_count field (if you have it)
  //   - qty_delivered field
  //   - invoiced_amount
  //
  // For this implementation, we'll sort by rating_count as a proxy for
  // popularity (higher review count = more purchases).
  // You can adjust this to use actual sales data if available.

  Future<dynamic> _getMostSold() async {
    return await getProducts(NoParams());
  }

  // ── Most Wanted ────────────────────────────────────────────────────
  //
  // "Most wanted" typically means:
  //   - Highest rating
  //   - New arrivals with high wishlist count
  //   - Products with high page views (if tracked)
  //
  // We'll use highest rating as the criteria here.

  Future<dynamic> _getMostWanted() async {
    return await getProducts(NoParams());
  }
}