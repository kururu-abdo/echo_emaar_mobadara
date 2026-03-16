import 'package:echoemaar_commerce/features/checkout/domain/entities/order_dtails.dart';
class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.lineId,
    required super.productId,
    required super.name,
    required super.productCode,
    required super.quantity,
    required super.quantityDelivered,
    required super.quantityInvoiced,
    required super.priceUnit,
    required super.priceSubtotal,
    required super.priceTotal,
    required super.tax,
    super.image,
  });

  // ── JSON to Model ────────────────────────────────────────────────
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      lineId: json['line_id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      name: json['product_name'] ?? '',
      productCode: json['product_code'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      quantityDelivered: (json['quantity_delivered'] as num?)?.toDouble() ?? 0.0,
      quantityInvoiced: (json['quantity_invoiced'] as num?)?.toDouble() ?? 0.0,
      priceUnit: (json['price_unit'] as num?)?.toDouble() ?? 0.0,
      priceSubtotal: (json['price_subtotal'] as num?)?.toDouble() ?? 0.0,
      priceTotal: (json['price_total'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      // Odoo often sends 'false' for null images, we convert to null
      image: (json['image'] is String) ? json['image'] : null,
    );
  }

  // ── Model to Entity ──────────────────────────────────────────────
  /// Maps the Data Model to the Domain Entity
  OrderItem toEntity() {
    return OrderItem(
      lineId: lineId,
      productId: productId,
      name: name,
      productCode: productCode,
      quantity: quantity,
      quantityDelivered: quantityDelivered,
      quantityInvoiced: quantityInvoiced,
      priceUnit: priceUnit,
      priceSubtotal: priceSubtotal,
      priceTotal: priceTotal,
      tax: tax,
      image: image,
    );
  }
}