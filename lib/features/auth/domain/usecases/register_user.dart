import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser implements UseCase<User, RegisterUserParams> {
  final AuthRepository repository;
  
  RegisterUser(this.repository);
  
  @override
  Future<Either<Failure, User>> call(RegisterUserParams params) async {
    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterUserParams {
  final String name;
  final String email;
  final String password;
  
  RegisterUserParams({
    required this.name,
    required this.email,
    required this.password,
  });
}