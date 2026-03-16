import 'package:dartz/dartz.dart' show Either;
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/products/domain/entities/product.dart';
import 'package:echoemaar_commerce/features/products/domain/repositories/product_repository.dart';

class GetFeaturedProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;
  
  GetFeaturedProducts(this.repository);
  
  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getFeaturedProducts(
     
    );
  }
}