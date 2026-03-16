
import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/country_state.dart';
import 'package:echoemaar_commerce/features/checkout/domain/repositories/checkout_repository.dart';

class GetCountryStates
    implements UseCase<List<CountryState>, int> {
  final CheckoutRepository repository;

  GetCountryStates(this.repository);

  @override
  Future<Either<Failure, List<CountryState>>> call(int country) async {
    return await repository.getCountryStates(country);
  }
}