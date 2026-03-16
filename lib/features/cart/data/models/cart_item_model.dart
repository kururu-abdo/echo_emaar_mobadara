import 'package:echoemaar_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/cart_item.dart';
class CartItemModel extends CartItem {
  const CartItemModel({
    required super.lineId,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.priceUnit,
    super.image,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {

    return CartItemModel(
      lineId: json['line_id'] as int,
      productId: json['product_id'] as int,
      productName: json['product_name'] ?? '',
      quantity: (json['quantity'] as num).toInt(),
      priceUnit: (json['price_unit'] as num).toDouble(),
      image: json['image']??'', // Matches your "image": null or URL
    );
  }

  CartItemModel copyWith({
    int? lineId,
    int? productId,
    String? productName,
    int? quantity,
    double? priceUnit,
    String? image,
  }) {
    return CartItemModel(
      lineId: lineId ?? this.lineId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      priceUnit: priceUnit ?? this.priceUnit,
      image: image ?? this.image,
    );
  }

  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      lineId: entity.lineId,
      productId: entity.productId,
      productName: entity.productName,
      quantity: entity.quantity,
      priceUnit: entity.priceUnit,
      image: entity.image,
    );
  }
CartItem toEntity() {
    return CartItem(
      lineId: lineId,
      productId: productId,
      productName: productName,
      quantity: quantity,
      priceUnit: priceUnit,
      image: image,
    );
}
  Map<String, dynamic> toJson() => {
        'line_id': lineId,
        'product_id': productId,
        'product_name': productName,
        'quantity': quantity,
        'price_unit': priceUnit,
        'image': image,
      };
    
}