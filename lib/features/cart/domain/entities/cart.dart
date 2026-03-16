// features/cart/domain/entities/cart.dart

import 'package:echoemaar_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:equatable/equatable.dart';




class Cart extends Equatable {
  final int? id;
  final String name;
  final int orderId;
  final double? total;
  final double? tax;
  final List<CartItem>? items;
  final bool? isGuest;  // NEW: flag to track cart type
  final DateTime lastSynced;  // NEW: for sync staleness check
    final double? subtotal;
     final double? discount;
  final double? shippingFee;

  const Cart({
    required this.id,
    required this.name,
        required this.orderId,

    required this.total,
    required this.tax,

    required this.items, required this.isGuest, required this.lastSynced, required this.subtotal, required this.discount, required this.shippingFee,
  });

  @override
  List<Object?> get props => [id, name,orderId, total, tax, items];


   double get totalItems => items!.fold<double>(0.0, (sum, item) => sum +( item.quantity??0.0));
  
  bool get isEmpty => items!.isEmpty;
  
  bool get needsSync => isGuest == false && 
                        DateTime.now().difference(lastSynced).inMinutes > 5;

  Cart copyWith({
    int? id,
    List<CartItemModel>? items,
    double? subtotal, 
    double? tax,
    double? discount,
    double? shippingFee,
    double? total,
String? name,
    bool? isGuest,
    DateTime? lastSynced,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
orderId: orderId,
      discount: discount ?? this.discount,
      shippingFee: shippingFee ?? this.shippingFee,
      total: total ?? this.total,
      isGuest: isGuest ?? this.isGuest,
      lastSynced: lastSynced ?? this.lastSynced, name: name?? this.name ,
    );
  }

}



/*
class Cart extends Equatable {
  final String? id;  // Odoo sale.order ID (null for guest)
  final List<CartItemModel> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double shippingFee;
  final double total;
  final bool isGuest;  // NEW: flag to track cart type
  final DateTime lastSynced;  // NEW: for sync staleness check

  const Cart({
    this.id,
    required this.items,
    required this.subtotal,
    this.tax = 0,
    this.discount = 0,
    this.shippingFee = 0,
    required this.total,
    this.isGuest = true,
    required this.lastSynced,
  });

  @override
  List<Object?> get props => [
    id,
    items,
    subtotal,
    tax,
    discount,
    shippingFee,
    total,
    isGuest,
    lastSynced,
  ];

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  bool get isEmpty => items.isEmpty;
  
  bool get needsSync => isGuest == false && 
                        DateTime.now().difference(lastSynced).inMinutes > 5;

  Cart copyWith({
    String? id,
    List<CartItemModel>? items,
    double? subtotal, 
    double? tax,
    double? discount,
    double? shippingFee,
    double? total,

    bool? isGuest,
    DateTime? lastSynced,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,

      discount: discount ?? this.discount,
      shippingFee: shippingFee ?? this.shippingFee,
      total: total ?? this.total,
      isGuest: isGuest ?? this.isGuest,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }



}
*/