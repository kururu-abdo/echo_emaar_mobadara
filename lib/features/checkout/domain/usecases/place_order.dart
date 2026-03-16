import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_confirmation.dart';
import '../repositories/checkout_repository.dart';

class PlaceOrder implements UseCase<OrderConfirmation, int> {
  final CheckoutRepository repository;

  PlaceOrder(this.repository);

  @override
  Future<Either<Failure, OrderConfirmation>> call(
      int orderId) async {
     return repository.placeOrder(orderId: orderId);
  }
}

class PlaceOrderParams extends Equatable {
  final OrderSummary orderSummary;

  const PlaceOrderParams(this.orderSummary);

  @override
  List<Object> get props => [orderSummary];
}