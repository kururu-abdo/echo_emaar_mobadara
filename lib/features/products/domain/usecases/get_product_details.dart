import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetails implements UseCase<Product, GetProductDetailsParams> {
  final ProductRepository repository;
  
  GetProductDetails(this.repository);
  
  @override
  Future<Either<Failure, Product>> call(GetProductDetailsParams params) async {
    return await repository.getProductDetails(params.productId);
  }
}

class GetProductDetailsParams {
  final int productId;
  
  GetProductDetailsParams(this.productId);
}