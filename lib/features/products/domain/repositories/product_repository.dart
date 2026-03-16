import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../entities/category.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts(
    
    
    /*
    {
    int? categoryId,
    int offset = 0,
    int limit = 20,
    String? sortBy,
  }
  */
  
  );
   Future<Either<Failure, List<Product>>> getMostSoldProducts(
    
    
    /*
    {
    int? categoryId,
    int offset = 0,
    int limit = 20,
    String? sortBy,
  }
  */
  
  );
  Future<Either<Failure, Product>> getProductDetails(int productId);
  
  Future<Either<Failure, List<Product>>> searchProducts({ 
    required String query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int limit = 20,
  });
  
  Future<Either<Failure, List<Category>>> getCategories();
  
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
  
  Future<Either<Failure, List<Product>>> getRelatedProducts(int productId);
}