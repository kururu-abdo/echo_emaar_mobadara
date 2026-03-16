import 'package:echoemaar_commerce/features/checkout/data/models/address_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/order_item_model.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order_dtails.dart';

class OrderDetailModel extends OrderDetail {
  const OrderDetailModel({
    required super.id, required super.name, required super.date,
    required super.state, required super.stateLabel,
    required super.deliveryStatus, required super.deliveryStatusLabel,
    required super.deliveryMessage, required super.total,
    required super.tax, required super.currency,
    required super.items, required super.address,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['order_id'],
      name: json['order_name'],
      date: DateTime.parse(json['order_date']),
      state: json['state'],
      stateLabel: json['state_label'],
      deliveryStatus: json['delivery_status'],
      deliveryStatusLabel: json['delivery_status_label'],
      deliveryMessage: json['delivery_message'],
      total: (json['amount_total'] as num).toDouble(),
      tax: (json['amount_tax'] as num).toDouble(),
      currency: json['currency'],
      address: ShippingAddressModel.fromOdoo(json['delivery_address']),
      items: (json['items'] as List)
          .map((i) => OrderItemModel.fromJson(i))
          .toList(),
    );
  }

  OrderDetail toEntity() {
    return OrderDetail(
      id: id,
      name: name,
      date: date,
      state: state,
      stateLabel: stateLabel,
      deliveryStatus: deliveryStatus,
      deliveryStatusLabel: deliveryStatusLabel,
      deliveryMessage: deliveryMessage,
      total: total,
      tax: tax,
      currency: currency,
      // Mapping nested lists to their entities
      items: items.map((item) => (item as OrderItemModel).toEntity()).toList(),
      // Converting nested address model
      address: (address as ShippingAddressModel).toEntity(),
    );
  }
}