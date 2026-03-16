import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;
  
  GetProducts(this.repository);
  
  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getProducts(
      // categoryId: params.categoryId,
      // offset: params.offset,
      // limit: params.limit,
      // sortBy: params.sortBy,
    );
  }
}

class GetProductsParams {
  final int? categoryId;
  final int offset;
  final int limit;
  final String? sortBy;
  
  GetProductsParams({
    this.categoryId,
    this.offset = 0,
    this.limit = 20,
    this.sortBy,
  });
}