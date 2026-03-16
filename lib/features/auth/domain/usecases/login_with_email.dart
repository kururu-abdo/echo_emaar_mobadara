
import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/auth/domain/entities/user.dart';
import 'package:echoemaar_commerce/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmail implements UseCase<User, LoginWithEmailParams> {
  final AuthRepository repository;
  
  LoginWithEmail(this.repository);
  
  @override
  Future<Either<Failure, User>> call(LoginWithEmailParams params) async {
    return await repository.loginWithEmail(params.email, params.password);
  }
}

class LoginWithEmailParams {
  final String email;
  final String password;
  
  LoginWithEmailParams({required this.email, required this.password});
}