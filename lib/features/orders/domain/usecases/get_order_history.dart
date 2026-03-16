// lib/features/orders/domain/usecases/get_orders_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/features/orders/domain/entities/order_history.dart';
import 'package:echoemaar_commerce/features/orders/domain/repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;
  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call({String status='all'}) async {
    return await repository.getOrders(state: status);
  }
}