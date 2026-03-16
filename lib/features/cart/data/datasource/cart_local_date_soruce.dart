// features/cart/data/datasources/cart_local_datasource.dart

import 'dart:developer';

import 'package:echoemaar_commerce/features/cart/data/models/cart_model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartLocalDataSource {
  Future<CartModel?> getCart();
  Future<void> saveCart(CartModel cart);
  Future<void> clearCart();
  
  // Guest flag management
  Future<bool> isGuestCart();
  Future<void> setGuestFlag(bool isGuest);
  
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _cartBox = 'cart';
  static const _cartKey = 'current_cart';
  static const _guestKey = 'is_guest';

  CartLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<CartModel?> getCart() async {
     final box = await _getCartBox();
    final raw = box.get(_cartKey);
    if (raw == null) return null;
    log("DATATYPE. ${raw.runtimeType}");
    return CartModel.fromJson(Map<String, dynamic>.from(raw));
  }
  
  @override
  Future<void> saveCart(CartModel cart) async {
     final box = await _getCartBox();
    await box.put(_cartKey, cart.toJson());
  }
  
  @override
  Future<bool> isGuestCart() async {
      // final box = await _getCartBox();
      // var sharedPre
    return sharedPreferences.getString('AUTH_TOKEN')==null;
  }
  
  @override
  Future<void> setGuestFlag(bool isGuest) async {
    final box = await _getCartBox();
    await box.put(_guestKey, isGuest);
  }
  
  @override
  Future<void> clearCart() async {
    final box = await _getCartBox();
    await box.clear();
  }

  Future<Box> _getCartBox() async {
  if (Hive.isBoxOpen(_cartBox)) {
    return Hive.box(_cartBox);  // Already open, just get it
  }
  return await Hive.openBox(_cartBox);  // Open if not open
}
}