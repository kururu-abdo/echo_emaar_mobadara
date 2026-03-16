import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/products/domain/usecases/get_most_sold_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/get_products.dart';
import '../../../domain/usecases/search_products.dart';
import '../../../domain/usecases/get_categories.dart';
import 'package:equatable/equatable.dart';

part ' product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProducts getProducts;
  final GetMostSoldProducts getMostSoldProducts;
  // final GetCategories getCategories;
  
  ProductListBloc({
    required this.getProducts,
    required this.getMostSoldProducts,
    // required this.getCategories,
  }) : super(ProductListInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
        on<LoadMostSoldProductsEvent>(_onLoadMostSoldProducts);

    // on<LoadMoreProductsEvent>(_onLoadMoreProducts);
    // on<SearchProductsEvent>(_onSearchProducts);
    // // on<LoadCategoriesEvent>(_onLoadCategories);
    // on<FilterByCategoryEvent>(_onFilterByCategory);
  }
  

  
  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    
    final result = await getProducts(
      NoParams()
    //   GetProductsParams(
    //   categoryId: event.categoryId,
    //   sortBy: event.sortBy,
    // )
    
    );
    
    result.fold(
      (failure) => emit(ProductListError(failure.message)),
      (products) => emit(ProductListLoaded(
        products,
        // hasReachedMax: products.length < 20,
      )),
    );
  }

    Future<void> _onLoadMostSoldProducts(
    LoadMostSoldProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    
    final result = await getMostSoldProducts(
      NoParams()
    //   GetProductsParams(
    //   categoryId: event.categoryId,
    //   sortBy: event.sortBy,
    // )
    
    );
    
    result.fold(
      (failure) => emit(ProductListError(failure.message)),
      (products) => emit(ProductListLoaded(
        products,
        // hasReachedMax: products.length < 20,
      )),
    );
  }
   /*
  Future<void> _onLoadMoreProducts(
    LoadMoreProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductListLoaded || currentState.hasReachedMax) {
      return;
    }
    
    final result = await getProducts(GetProductsParams(
      categoryId: event.categoryId,
      offset: currentState.products.length,
      sortBy: event.sortBy,
    ));
    
    result.fold(
      (failure) => emit(ProductListError(failure.message)),
      (newProducts) => emit(ProductListLoaded(
        products: [...currentState.products, ...newProducts],
        hasReachedMax: newProducts.length < 20,
      )),
    );
  }
  
  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    
    final result = await searchProducts(SearchProductsParams(event.query));
    
    result.fold(
      (failure) => emit(ProductListError(failure.message)),
      (products) => emit(ProductListLoaded(
        products: products,
        hasReachedMax: true,
      )),
    );
  }
 
  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<ProductListState> emit,
  ) async {
    // Implementation for loading categories
  }

  Future<void> _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    
    final result = await getProducts(GetProductsParams(
      categoryId: event.categoryId,
    ));
    
    result.fold(
      (failure) => emit(ProductListError(failure.message)),
      (products) => emit(ProductListLoaded(
        products: products,
        hasReachedMax: products.length < 20,
      )),
    );
  }

  */

}