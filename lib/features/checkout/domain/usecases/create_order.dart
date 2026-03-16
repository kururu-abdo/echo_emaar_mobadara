import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_method.dart';
import '../repositories/checkout_repository.dart';

class CreateOrderSummary
    implements UseCase<OrderSummary, CreateOrderSummaryParams> {
  final CheckoutRepository repository;

  CreateOrderSummary(this.repository);

  @override
  Future<Either<Failure, OrderSummary>> call(
      CreateOrderSummaryParams params) async {
    return await repository.createOrderSummary(
      cartId: params.cartId,
      shippingAddressId: params.shippingAddressId,
      paymentMethod: params.paymentMethod,
      notes: params.notes,
    );
  }
}

class CreateOrderSummaryParams extends Equatable {
  final int cartId;
  final int shippingAddressId;
  final PaymentMethod paymentMethod;
  final String? notes;

  const CreateOrderSummaryParams({
    required this.cartId,
    required this.shippingAddressId,
    required this.paymentMethod,
    this.notes,
  });

  @override
  List<Object?> get props => [cartId, shippingAddressId, paymentMethod, notes];
}