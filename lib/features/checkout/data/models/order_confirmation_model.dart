import 'package:echoemaar_commerce/features/checkout/domain/entities/order_confirmation.dart';

class OrderConfirmationModel extends OrderConfirmation {
  const OrderConfirmationModel({
    required super.id,
    required super.orderReference,
    required super.state,
    required super.totalAmount,
    required super.orderDate,
  });

  factory OrderConfirmationModel.fromJson(Map<String, dynamic> json) {
    return OrderConfirmationModel(
      id: json['order_id'] as int,
      orderReference: json['order_name'] ?? '',
      state: json['state'] ?? '',
      totalAmount: (json['amount_total'] as num?)?.toDouble() ?? 0.0,
      orderDate: json['order_date'] != null 
          ? DateTime.parse(json['order_date']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'order_id': id,
    'order_name': orderReference,
    'state': state,
    'amount_total': totalAmount,
    'order_date': orderDate.toIso8601String(),
  };
}