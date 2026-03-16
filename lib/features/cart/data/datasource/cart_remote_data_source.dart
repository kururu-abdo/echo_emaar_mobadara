// features/cart/data/datasources/cart_remote_datasource.dart

import 'dart:developer';

import 'package:echoemaar_commerce/config/constants/api_constants.dart';
import 'package:echoemaar_commerce/core/network/odoo_http_client.dart';
import 'package:echoemaar_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:echoemaar_commerce/features/cart/data/models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<CartModel> createOrUpdateCart(List<CartItemModel> items);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final OdooHttpClient odooClient;
  
  CartRemoteDataSourceImpl({required this.odooClient});
  
  @override
  Future<CartModel> getCart() async {
    // Search for user's draft sale.order
    final orders = await odooClient.restGet(ApiConstants.cartEndpiint, 
    
    );
   
    if (orders.isEmpty) {
      // No cart exists, return empty
      return CartModel.empty();
    }
    log('REMOTE CART: $orders');
    
    return CartModel.fromOdoo(orders['cart']);
  }
  
  @override
  Future<CartModel> createOrUpdateCart(List<CartItemModel> items) async {
    // Get or create cart order
    final existingOrders = await getCart();
    log('EXISTING ${existingOrders.items}');
    int? orderId;
    log(existingOrders.isEmpty.toString());
    if (existingOrders.items!.isEmpty) {
      // Create new cart
        await odooClient.restPost(
      ApiConstants.addToCartEndpiint, 
      body: {
        'items': items.map((item)=>{
          "product_id": item.productId, "quantity":item.quantity
        }).toList()
      }
    );
    } else {
      log('UPDATING===================>');
      orderId = existingOrders.id as int;
     
      // Clear existing lines
      final existingLines = await odooClient.restPost(
       ApiConstants.updateCartEndpiint, 
        body: {
        'items': items.map((item)=>{
          "product_id": item.productId, "quantity":item.quantity
        }).toList()
      }
      );
      final order = await getCart();
      if (existingLines.isNotEmpty) {
        // await odooClient.unlink(
        //   'sale.order.line',
        //   existingLines.map((l) => l['id'] as int).toList(),
        // );
      }

      return order;
    }
    
    // Add all items
    for (final item in items) {
      await odooClient.restPost(
      ApiConstants.addToCartEndpiint, 
      body: {
        'items':{
          "product_id": item.productId, "quantity":item.quantity
        }
      }
    );
    }
    
    // Fetch updated cart
    return getCart();
  }
  
  @override
  Future<void> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }
}