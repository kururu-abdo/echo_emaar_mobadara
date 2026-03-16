import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/network/network_info.dart';
import 'package:echoemaar_commerce/features/checkout/data/datasources/checkout_local_datasource.dart';
import 'package:echoemaar_commerce/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/address_model.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/country.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/country_state.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order_confirmation.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/payment_method.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/shipping_address.dart';
import 'package:echoemaar_commerce/features/checkout/domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;
  final CheckoutLocalDatasource localDataSource;
  final NetworkInfo networkInfo;

  CheckoutRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo, required this.localDataSource,
  });

  // --- Shipping Addresses ---

  @override
  Future<Either<Failure, ShippingAddressModel>> getShippingAddresses() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure(''));

    try {
      final remoteAddresses = await remoteDataSource.getAddresses();
      return Right(remoteAddresses);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ShippingAddress>> addShippingAddress(ShippingAddress address) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure(''));

    try {
      // Convert Entity to Model for the toOdoo() call in DataSource
      final model = ShippingAddressModel.fromEntity(address);
      final result = await remoteDataSource.addAddress(model);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ShippingAddress>> updateShippingAddress(ShippingAddress address) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure(''));

    try {
      final model = ShippingAddressModel.fromEntity(address);
      final result = await remoteDataSource.addAddress(model);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteShippingAddress(int addressId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure(''));

    try {
      await remoteDataSource.deleteAddress(addressId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  // --- Checkout Process ---

  @override
  Future<Either<Failure, OrderSummary>> createOrderSummary({
    required int cartId,
    required int shippingAddressId,
    required PaymentMethod paymentMethod,
    String? notes,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure(''));

    try {
      final summary = await remoteDataSource.getOrderSummary(
        cartId: cartId,
        addressId: shippingAddressId,
        paymentMethod: paymentMethod.displayName,
        notes: notes,
      );
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, OrderConfirmation>> placeOrder({
    // required OrderSummary orderSummary,
        required int orderId
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure(''));

    try {
      // final confirmation = 
     var order= await remoteDataSource.confirmOrder(orderId);
      return Right( order);

      // return Right(confirmation);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> processPayment({
    required OrderSummary orderSummary,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure(''));

    try {
      final success = await remoteDataSource.validatePayment(0);
      return Right(success);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, double>> calculateShippingFee(int shippingAddressId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure(''));

    try {
      final fee = await remoteDataSource.getShippingFee(shippingAddressId);
      return Right(fee);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Country>>> getCountries()async { if (await networkInfo.isConnected) {
      try {
        final countries = await remoteDataSource.getcountries(
         
        );
        
     
        localDataSource.cacheCountries(countries);
        return Right(countries);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final cachedCountries = await localDataSource.getCachedCountries();
        return Right(cachedCountries);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<CountryState>>> getCountryStates(int country) async{
    if (await networkInfo.isConnected) {
    
    try {
        final states = await remoteDataSource.getCountryStates(
         country
        );
        
     
        localDataSource.cacheStates(country, states);
        return Right(states);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final cachedCountries = await localDataSource.getCachedStates(country);
        return Right(cachedCountries);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }}
  
}