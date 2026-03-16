// lib/features/orders/data/models/order_model.dart
import 'package:echoemaar_commerce/features/orders/domain/entities/order_history.dart';


class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.name,
    required super.dateOrder,
    required super.state,
    required super.amountTotal,
    required super.amountUntaxed,
    required super.amountTax,
    super.priceState,
  });

  // ── JSON to Model ────────────────────────────────────────────────
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      dateOrder: json['date_order'] != null 
          ? DateTime.parse(json['date_order']) 
          : DateTime.now(),
      state: json['state'] ?? 'draft',
      amountTotal: (json['amount_total'] as num?)?.toDouble() ?? 0.0,
      amountUntaxed: (json['amount_untaxed'] as num?)?.toDouble() ?? 0.0,
      amountTax: (json['amount_tax'] as num?)?.toDouble() ?? 0.0,
      priceState: json['price_state']?.toString(),
    );
  }

  // ── Model to JSON (For Local Caching) ────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_order': dateOrder.toIso8601String(),
      'state': state,
      'amount_total': amountTotal,
      'amount_untaxed': amountUntaxed,
      'amount_tax': amountTax,
      'price_state': priceState,
    };
  }

  // ── Model to Entity ──────────────────────────────────────────────
  OrderEntity toEntity() => OrderEntity(
    id: id,
    name: name,
    dateOrder: dateOrder,
    state: state,
    amountTotal: amountTotal,
    amountUntaxed: amountUntaxed,
    amountTax: amountTax,
    priceState: priceState,
  );
}