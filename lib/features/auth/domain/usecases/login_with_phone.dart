import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginWithPhone implements UseCase<User, LoginWithPhoneParams> {
  final AuthRepository repository;
  
  LoginWithPhone(this.repository);
  
  @override
  Future<Either<Failure, User>> call(LoginWithPhoneParams params) async {
    log('LOGIN WITH EMAIL');
    return await repository.loginWithPhone(params.phone,);
  }
}

class LoginWithPhoneParams {
  final String phone;
  final String password;
  
  LoginWithPhoneParams({required this.phone, required this.password});
}