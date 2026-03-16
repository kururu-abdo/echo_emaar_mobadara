import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/order_details_model.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order_dtails.dart';
import 'package:echoemaar_commerce/features/orders/domain/repositories/order_repository.dart';

class GetOrderDetailsUseCase {
  final OrderRepository repository;
  GetOrderDetailsUseCase(this.repository);

  Future<Either<Failure, OrderDetail>> call(int order) async {
    return await repository.getOrderDetails(order );

  }
}