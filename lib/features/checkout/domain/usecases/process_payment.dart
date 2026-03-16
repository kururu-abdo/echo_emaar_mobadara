import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/checkout_repository.dart';

class ProcessPayment implements UseCase<bool, ProcessPaymentParams> {
  final CheckoutRepository repository;

  ProcessPayment(this.repository);

  @override
  Future<Either<Failure, bool>> call(ProcessPaymentParams params) async {
    return await repository.processPayment(orderSummary: params.orderSummary);
  }
}

class ProcessPaymentParams extends Equatable {
  final OrderSummary orderSummary;

  const ProcessPaymentParams(this.orderSummary);

  @override
  List<Object> get props => [orderSummary];
}