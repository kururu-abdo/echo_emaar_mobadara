
import 'dart:developer';

import 'package:echoemaar_commerce/features/cart/domain/entities/cart.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';
import '../../domain/entities/cart.dart';
import 'cart_item_model.dart';

import 'cart_item_model.dart';

class CartModel extends Cart {
  const CartModel(
    {
    super.id,
    required super.items,
    required super.subtotal,
    super.tax,
    super.discount,
    super.shippingFee,
    required super.total,
    super.isGuest,
    required super.lastSynced, required super.name, required super.orderId,
  });

  // ── Empty Cart ─────────────────────────────────────────────────────
  factory CartModel.empty() {
    return CartModel(
      items: const [],
      subtotal: 0,
      orderId: 0,
      total: 0,
      isGuest: true,
      lastSynced: DateTime.now(), name: '',
      tax: 0,discount: 0,  
    );
  }

  // ── From Hive Cache / Local JSON ───────────────────────────────────
  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    final items = itemsList
        .map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();

    return CartModel(
      id: json['order_id']??json['id'],
      orderId: json['order_id']??json['id'], 
      items: items,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      shippingFee: (json['shipping_fee'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      isGuest: json['is_guest'] as bool? ?? true,
      lastSynced: json['last_synced'] != null
          ? DateTime.parse(json['last_synced']??DateTime.now())
          : DateTime.now(), name:  json['order_name']??'',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'items': items!.map((item) => (item as CartItemModel).toJson()).toList(),
        'subtotal': subtotal,
        'tax': tax,
        'discount': discount,
        'shipping_fee': shippingFee,
        'total': total,
        'is_guest': isGuest,
        'last_synced': lastSynced.toIso8601String(),
      };

  // ── From Odoo sale.order (UPDATED PATTERN) ─────────────────────────
  factory CartModel.fromOdoo(Map<String, dynamic> odooOrder) {
    // The pattern you provided uses 'lines' for items
    final linesList = odooOrder['lines'] as List? ?? [];
    
    final items = linesList
        .map((line) => CartItemModel.fromJson(Map<String, dynamic>.from(line as Map)))
        .toList();

    return CartModel(
      // Mapping Odoo's 'order_id' to our 'id'
      id: odooOrder['order_id'],
      orderId: odooOrder['order_id'],
      items: items,
      
      // Mapping Odoo's specific naming pattern
      subtotal: (odooOrder['amount_untaxed'] as num?)?.toDouble() ?? 0,
      tax: (odooOrder['amount_tax'] as num?)?.toDouble() ?? 0,
      discount: (odooOrder['amount_discount'] as num?)?.toDouble() ?? 0,
      // Odoo usually calls shipping 'delivery_price' or 'amount_delivery'
      shippingFee: (odooOrder['shipping_fee'] as num?)?.toDouble() ?? 0, 
      total: (odooOrder['amount_total'] as num?)?.toDouble() ?? 0,
      isGuest: false,
      lastSynced: DateTime.now(), name: odooOrder['order_name'],
    );
  }

  // ── To Odoo sale.order format ──────────────────────────────────────
  Map<String, dynamic> toOdooOrder() => {
        if (id != null) 'order_id': id,
        'state': 'draft',
        // Odoo format for updating lines: [0, 0, {values}] to add, [1, id, {values}] to update
        'lines': items!
            .map((item) => [0, 0, (item as CartItemModel).toJson()])
            .toList(),
      };

  // ── Recalculate totals (Business Logic) ────────────────────────────
  CartModel _recalculate(List<CartItemModel> items) {
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.priceUnit* item.quantity);
    
    // Example: Update tax and total based on subtotal
    final tax = subtotal * 0.15; // Assuming 15% VAT
    final total = subtotal + tax + (shippingFee??0.0 )- (discount??0.0);

    return copyWith(
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      lastSynced: DateTime.now(),
    );
  }

  // ── Helper Operations ──────────────────────────────────────────────
  CartModel addItem(CartItemModel newItem) {
    final List<CartItemModel> updatedItems = List.from(items as  List<CartItemModel> );
    final index = updatedItems.indexWhere((i) => i.productId == newItem.productId);
    
    if (index != -1) {
      updatedItems[index] = updatedItems[index].copyWith(
        quantity: updatedItems[index].quantity + newItem.quantity,
      );
    } else {
      updatedItems.add(newItem);
    }
    return _recalculate(updatedItems);
  }

  @override
  CartModel copyWith({
    int? id,
    List<CartItemModel>? items,
    double? subtotal,
    double? tax,
    double? discount,
    double? shippingFee,
    double? total,
    bool? isGuest,
    DateTime? lastSynced,
    String? name, 
    int? orderId
  }) {
    return CartModel(
      id: id ?? this.id,
      items: items ?? this.items!.cast<CartItemModel>(),
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      shippingFee: shippingFee ?? this.shippingFee,
      total: total ?? this.total,
      isGuest: isGuest ?? this.isGuest,
      orderId: orderId??this.orderId,
      lastSynced: lastSynced ?? this.lastSynced, name: name?? this.name,
    );
  }

  // Inside features/cart/data/models/cart_model.dart
/*
CartModel updateItemQuantity(String itemId, int quantity) {
  final updatedItems = items!.map((item) {
    if (item.lineId.toString() == itemId) {
      // Cast to CartItemModel to use copyWith
    log('item to update================================> $item quantity $quantity ');

      return (item as CartItemModel).copyWith(quantity: quantity.toInt());
    }
    return item as CartItemModel;
  }).toList();
  
  return _recalculate(updatedItems);
}
*/


CartModel updateItemQuantity(String itemId, int quantity) {
  log('🔧 CartModel updateItemQuantity: itemId=$itemId, quantity=$quantity');
  log('🔧 Current items: ${items!.map((i) => "id=${i.productId}, qty=${i.quantity}").join(", ")}');
  
  final updatedItems = items!.map((item) {
    if (item.productId.toString() == itemId) {
      log('🔧 Found matching item! Updating quantity');
      return (item as CartItemModel).copyWith(quantity: quantity).toEntity();
    }
    return item;
  }).toList();
  
  return _recalculate(updatedItems.map((item)=> CartItemModel.fromEntity(item)).toList());
}


CartModel removeItem(String itemId) {
  log('🔧 CartModel removeItem: itemId=$itemId');
  // Filter out the item with the matching ID
  final updatedItems = items!
      .where((item) => item.productId.toString() != itemId)
      // .cast<CartItemModel>()
      .toList();
log('ITEMS AFTETR REMOVE ======================>$updatedItems');
  // Return a new CartModel instance with updated totals
  return _recalculate(updatedItems.map((item)=> CartItemModel.fromEntity(item)).toList());
}
}