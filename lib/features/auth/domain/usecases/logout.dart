import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/auth/domain/entities/user.dart';
import 'package:echoemaar_commerce/features/auth/domain/repositories/auth_repository.dart';
class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;
  
  Logout(this.repository);
  
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}