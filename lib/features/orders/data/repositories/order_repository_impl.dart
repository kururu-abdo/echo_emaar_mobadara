import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/network/network_info.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order_dtails.dart';
import 'package:echoemaar_commerce/features/orders/data/datasources/order_local_datasource.dart';
import 'package:echoemaar_commerce/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:echoemaar_commerce/features/orders/domain/entities/order_history.dart';
import 'package:echoemaar_commerce/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders({String state = 'sale'}) async {
    // 1. Try to fetch from API if connected
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await remoteDataSource.getOrders(state: state);
        
        // 2. Cache the data locally for offline use
        await localDataSource.cacheOrders(remoteOrders);
        
        // 3. Return the clean entities
        return Right(remoteOrders.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure( e.toString()));
      }
    } else {
      // 4. Offline mode: Load from local storage
      try {
        final localOrders = localDataSource.getCachedOrders();
        if (localOrders.isNotEmpty) {
          return Right(localOrders.map((model) => model.toEntity()).toList());
        } else {
          return const Left(NetworkFailure( "No internet and no cached data"));
        }
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, OrderDetail>> getOrderDetails(int order) async{ 
    if (await networkInfo.isConnected) {
      try {
        final orderDetails = await remoteDataSource.getOrderDetails(order);
        
        // 2. Cache the data locally for offline use
        // await localDataSource.cacheOrders(remoteOrders);
        
        // 3. Return the clean entities
        return Right(orderDetails.toEntity());
      } catch (e) {
        return Left(ServerFailure( e.toString()));
      }
    }
    else {
      // 4. Offline mode: Load from local storage
   return const Left(NetworkFailure( "No internet and no cached data"));
    }
  }
    

  
}