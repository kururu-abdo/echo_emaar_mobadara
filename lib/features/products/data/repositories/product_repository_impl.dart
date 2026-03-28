import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int? categoryId,
    int offset = 0,
    int limit = 20,
    String? sortBy,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts(
          categoryId: categoryId,
          offset: offset,
          limit: limit,
          sortBy: sortBy,
        );
        
        // Cache the products if it's the first page
        if (offset == 0) {
          await localDataSource.cacheProducts(products);
        }
        
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        return Right(cachedProducts);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
  
  @override
  Future<Either<Failure, Product>> getProductDetails(int productId) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductDetails(productId);
        await localDataSource.cacheProductDetails(product);
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final cachedProduct = await localDataSource.getCachedProductDetails(productId);
        if (cachedProduct == null) {
          return const Left(CacheFailure('Product not found in cache'));
        }
        return Right(cachedProduct);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> searchProducts({ 
    required String query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final products = await remoteDataSource.searchProducts(query);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  /*
  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        await localDataSource.cacheCategories(categories);
        return Right(categories);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final cachedCategories = await localDataSource.getCachedCategories();
        return Right(cachedCategories);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
  */
  @override
  Future<Either<Failure, List<Product>>> getFeaturedProducts() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final products = await remoteDataSource.getFeaturedProducts();
      log('BIG FAILURE $products');
      return Right(products);
    } on ServerException catch (e){
          log('BIG FAILURE ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> getRelatedProducts(int productId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final products = await remoteDataSource.getRelatedProducts(productId);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Category>>> getCategories()async {
  // if (!await networkInfo.isConnected) {
  //     return const Left(NetworkFailure('No internet connection'));
  //   }
    
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
   @override
  Future<Either<Failure, List<Product>>> getMostSoldProducts({
    int? categoryId,
    int offset = 0,
    int limit = 20,
    String? sortBy,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts(
          categoryId: categoryId,
          offset: offset,
          limit: limit,
          sortBy: sortBy,
        );
        
        // Cache the products if it's the first page
        if (offset == 0) {
          await localDataSource.cacheProducts(products);
        }
        
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        return Right(cachedProducts);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
  
}