
// ═══════════════════════════════════════════════════════════════════
// FILE: features/checkout/domain/entities/order_confirmation.dart
// ═══════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';

class OrderConfirmation extends Equatable {
  final int id;
  final String orderReference; // SO0022
  final String state;          // sale
  final double totalAmount;
  final DateTime orderDate;

  const OrderConfirmation({
    required this.id,
    required this.orderReference,
    required this.state,
    required this.totalAmount,
    required this.orderDate,
  });

  @override
  List<Object?> get props => [id, orderReference, state, totalAmount, orderDate];
}