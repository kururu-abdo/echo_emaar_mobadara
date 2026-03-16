import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/country.dart';
import 'package:echoemaar_commerce/features/checkout/domain/repositories/checkout_repository.dart';

class GetCountries
    implements UseCase<List<Country>, NoParams> {
  final CheckoutRepository repository;

  GetCountries(this.repository);

  @override
  Future<Either<Failure, List<Country>>> call(NoParams params) async {
    return await repository.getCountries();
  }
}