import 'dart:convert';

import 'package:echoemaar_commerce/features/orders/data/models/order_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderLocalDataSource {
  final SharedPreferences sharedPreferences;
  OrderLocalDataSource({required this.sharedPreferences});

  static const String _orderKey = 'CACHED_ORDERS';

  Future<void> cacheOrders(List<OrderModel> ordersToCache) async {
    final List<String> jsonList = ordersToCache
        .map((order) => jsonEncode(order.toJson()))
        .toList();
    await sharedPreferences.setStringList(_orderKey, jsonList);
  }

  List<OrderModel> getCachedOrders() {
    final jsonList = sharedPreferences.getStringList(_orderKey);
    if (jsonList != null) {
      return jsonList
          .map((item) => OrderModel.fromJson(jsonDecode(item)))
          .toList();
    }
    return [];
  }
}