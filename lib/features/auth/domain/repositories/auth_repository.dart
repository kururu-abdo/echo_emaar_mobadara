import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> loginWithPhone(String phone);
  Future<Either<Failure, User>> loginWithEmail(String email, String password);


  Future<Either<Failure, String>> sendOtp(String phone);
  Future<Either<Failure, User>> verifyOtp(String phone, String otp);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();


   Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  });
  

  
  Future<Either<Failure, bool>> checkPhoneExists(String phoneNumber);
}