import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProducts implements UseCase<List<Product>, SearchProductsParams> {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(SearchProductsParams params) async {
    return await repository.searchProducts(
      query: params.query,
      categoryId: params.categoryId,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      limit: params.limit,
    );
  }
}

class SearchProductsParams extends Equatable {
  final String query;
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final int limit;

  const SearchProductsParams({
    required this.query,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [query, categoryId, minPrice, maxPrice, limit];
}