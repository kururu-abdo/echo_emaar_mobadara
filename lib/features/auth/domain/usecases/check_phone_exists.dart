import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckPhoneExists implements UseCase<bool, CheckPhoneExistsParams> {
  final AuthRepository repository;
  
  CheckPhoneExists(this.repository);
  
  @override
  Future<Either<Failure, bool>> call(CheckPhoneExistsParams params) async {
    return await repository.checkPhoneExists(params.phoneNumber);
  }
}

class CheckPhoneExistsParams {
  final String phoneNumber;
  
  CheckPhoneExistsParams(this.phoneNumber);
}