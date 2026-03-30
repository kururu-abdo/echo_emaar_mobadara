import 'dart:developer';

import 'package:echoemaar_commerce/features/checkout/domain/entities/order_dtails.dart';
import 'package:echoemaar_commerce/features/orders/domain/entities/order_history.dart';
import 'package:echoemaar_commerce/features/orders/domain/usecases/get_order_details.dart';
import 'package:echoemaar_commerce/features/orders/domain/usecases/get_order_history.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final GetOrdersUseCase getOrdersUseCase;
  final GetOrderDetailsUseCase getOrderDetailsUseCase;
  OrderProvider({required this.getOrdersUseCase, required this.getOrderDetailsUseCase});
// ... existing variables ...
  String _selectedFilter = 'all'; // 'all', 'sale', 'draft'

  String get selectedFilter => _selectedFilter;
  List<OrderEntity> orders = [];
  bool isLoading = false;
OrderDetail? _currentOrder;
  OrderDetail? get currentOrder => _currentOrder;

  bool isDetailsLoading = false;
  String? detailsError;
  Future<void> fetchOrders() async {
    isLoading = true;
    notifyListeners();

    final result = await getOrdersUseCase(status: _selectedFilter=='all'?'': _selectedFilter);
    result.fold(
      (failure) => print(failure.message),
      (data) => orders = data,
    );

    isLoading = false;
    notifyListeners();
  }


  void setFilter(String filter) {
    log('GET========================================================== $selectedFilter');
    _selectedFilter = filter;
    notifyListeners();
    fetchOrders();
  }

  /// Fetches the full details of a specific order
  Future<void> fetchOrderDetails(int orderId) async {
    isDetailsLoading = true;
    detailsError = null;
    _currentOrder = null; // Clear previous order to avoid showing old data
    notifyListeners();

    final result = await getOrderDetailsUseCase(orderId);

    result.fold(
      (failure) {
        log('ERROR $failure');
        detailsError = failure.message;
        isDetailsLoading = false;
        notifyListeners();
      },
      (orderDetail) {
        _currentOrder = orderDetail;
        isDetailsLoading = false;
        notifyListeners();
      },
    );
  }

  /// Helper to clear details when leaving the screen
  void clearDetails() {
    _currentOrder = null;
    notifyListeners();
  }
}