import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final user = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      
      // Don't cache user yet - wait for phone verification
      
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, String>> sendOtp(String phoneNumber) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final message = await remoteDataSource.sendOtp(phoneNumber);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> verifyOtp(String phoneNumber, String otp) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final user = await remoteDataSource.verifyOtp(phoneNumber, otp);
      
      // Cache user after successful verification
      await localDataSource.cacheUser(user);
      
      // Generate and save auth token (in production, get from backend)
      final token = 'token_${user.uid}_${DateTime.now().millisecondsSinceEpoch}';
      await localDataSource.saveAuthToken(token);
      
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = await localDataSource.getAuthToken();
      if (token == null) {
        return const Right(null);
      }
      
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, bool>> checkPhoneExists(String phoneNumber) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final exists = await remoteDataSource.checkPhoneExists(phoneNumber);
      return Right(exists);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
    @override
  Future<Either<Failure, User>> loginWithEmail(String email, String password)async {
  // if (!await networkInfo.isConnected) {
  //     return const Left(NetworkFailure('No internet connection'));
  //   }
    
    try {
      log('EMAIL: $email');
      final exists = await remoteDataSource.loginWithEmail(email, password);
     localDataSource.cacheUser(exists);
     localDataSource.saveAuthToken(exists.sessionId);
     
      return Right(exists);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
  @override
  Future<Either<Failure, User>> loginWithPhone(String phone,) {
    // TODO: implement loginWithPhone
    throw UnimplementedError();
  }
}