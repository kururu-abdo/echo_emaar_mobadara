import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shipping_address.dart';
import '../repositories/checkout_repository.dart';

class AddShippingAddress
    implements UseCase<ShippingAddress, AddShippingAddressParams> {
  final CheckoutRepository repository;

  AddShippingAddress(this.repository);

  @override
  Future<Either<Failure, ShippingAddress>> call(
      AddShippingAddressParams params) async {
        log('PARMS: $params');
    return await repository.addShippingAddress(params.address);
  }
}

class AddShippingAddressParams extends Equatable {
  final ShippingAddress address;

  const AddShippingAddressParams(this.address);

  @override
  List<Object> get props => [address];
}