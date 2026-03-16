import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order_dtails.dart';
import 'package:echoemaar_commerce/features/orders/domain/entities/order_history.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders({String state = 'sale'});
    Future<Either<Failure, OrderDetail>> getOrderDetails(int order);

}