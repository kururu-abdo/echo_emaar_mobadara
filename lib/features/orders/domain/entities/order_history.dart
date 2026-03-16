// lib/features/orders/domain/entities/order_entity.dart
import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/features/orders/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';

// class OrderEntity extends Equatable {
//   final int id;
//   final String reference;
//   final DateTime date;
//   final double amountTotal;
//   final String status;

//   const OrderEntity({required this.id, required this.reference, required this.date, required this.amountTotal, required this.status});

//   @override
//   List<Object?> get props => [id, reference, status];
// }

import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int id;
  final String name;
  final DateTime dateOrder;
  final String state;
  final double amountTotal;
  final double amountUntaxed;
  final double amountTax;
  final String? priceState;

  const OrderEntity({
    required this.id,
    required this.name,
    required this.dateOrder,
    required this.state,
    required this.amountTotal,
    required this.amountUntaxed,
    required this.amountTax,
    this.priceState,
  });

  @override
  List<Object?> get props => [id, name, state, amountTotal];
}