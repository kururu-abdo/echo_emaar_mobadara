import 'package:echoemaar_commerce/features/checkout/domain/entities/shipping_address.dart';
import 'package:equatable/equatable.dart';

class OrderDetail extends Equatable {
  final int id;
  final String name;
  final DateTime date;
  final String state;
  final String stateLabel;
  final String deliveryStatus;
  final String deliveryStatusLabel;
  final String deliveryMessage;
  final double total;
  final double tax;
  final String currency;
  final List<OrderItem> items;
  final ShippingAddress address;

  const OrderDetail({
    required this.id, required this.name, required this.date,
    required this.state, required this.stateLabel,
    required this.deliveryStatus, required this.deliveryStatusLabel,
    required this.deliveryMessage, required this.total,
    required this.tax, required this.currency,
    required this.items, required this.address,
  });

  @override
  List<Object?> get props => [id, name, state, deliveryStatus];
}

class OrderItem extends Equatable {
  final int lineId;
  final int productId;
  final String name;
  final String productCode;
  final double quantity;
  final double quantityDelivered;
  final double quantityInvoiced;
  final double priceUnit;
  final double priceSubtotal;
  final double priceTotal;
  final double tax;
  final String? image;

  const OrderItem({
    required this.lineId,
    required this.productId,
    required this.name,
    required this.productCode,
    required this.quantity,
    required this.quantityDelivered,
    required this.quantityInvoiced,
    required this.priceUnit,
    required this.priceSubtotal,
    required this.priceTotal,
    required this.tax,
    this.image,
  });

  @override
  List<Object?> get props => [lineId, productId, quantity, priceTotal];
}