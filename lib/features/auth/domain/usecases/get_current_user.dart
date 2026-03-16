
import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/auth/domain/entities/user.dart';
import 'package:echoemaar_commerce/features/auth/domain/repositories/auth_repository.dart';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<User?, NoParams> {
  final AuthRepository repository;
  
  GetCurrentUser(this.repository);
  
  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}