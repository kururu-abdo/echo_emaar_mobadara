
import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/products/domain/entities/category.dart';
import 'package:echoemaar_commerce/features/products/domain/entities/product.dart';
import 'package:echoemaar_commerce/features/products/domain/repositories/product_repository.dart';

class GetCategories implements UseCase<List<Category>, NoParams> {
  final ProductRepository repository;
  
  GetCategories(this.repository);
  
  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getCategories(
      // categoryId: params.categoryId,
      // offset: params.offset,
      // limit: params.limit,
      // sortBy: params.sortBy,
    );
  }
}