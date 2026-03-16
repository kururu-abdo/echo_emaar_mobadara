
import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/products/domain/entities/product.dart';
import 'package:echoemaar_commerce/features/products/domain/repositories/product_repository.dart';

class GetMostSoldProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;
  
  GetMostSoldProducts(this.repository);
  
  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getMostSoldProducts(
     
    );
  }
}