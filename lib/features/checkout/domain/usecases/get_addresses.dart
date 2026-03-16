import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shipping_address.dart';
import '../repositories/checkout_repository.dart';

class GetShippingAddresses
    implements UseCase<ShippingAddress, NoParams> {
  final CheckoutRepository repository;

  GetShippingAddresses(this.repository);

  @override
  Future<Either<Failure, ShippingAddress>> call(NoParams params) async {
    return await repository.getShippingAddresses();
  }
}