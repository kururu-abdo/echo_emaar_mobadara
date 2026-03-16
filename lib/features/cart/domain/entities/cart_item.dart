
// features/cart/domain/entities/cart_item.dart

import 'package:equatable/equatable.dart';


class CartItem extends Equatable {
  final int lineId;
  final int productId;
  final String productName;
  final int quantity;
  final double priceUnit;
  final String? image;

  const CartItem({
    required this.lineId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceUnit,
    this.image,
  });

  @override
  List<Object?> get props => [lineId, productId, productName, quantity, priceUnit, image];
}


/*
class CartItem extends Equatable {
  final String id;  // Local UUID
  final int productId;
  final String productName;
  final String? productImage;
  final double unitPrice;
  final int quantity;
  final int? variantId;
  final String? variantName;
  final double discount;
  
  const CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.unitPrice,
    required this.quantity,
    this.variantId,
    this.variantName,
    this.discount = 0,
  });
  
  double get total => (unitPrice * quantity) - discount;
  
  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    productImage,
    unitPrice,
    quantity,
    variantId,
    variantName,
    discount,
  ];
}

*/