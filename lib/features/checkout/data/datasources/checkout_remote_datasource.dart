import 'dart:developer';

import 'package:echoemaar_commerce/config/constants/api_constants.dart';
import 'package:echoemaar_commerce/core/network/api_client.dart';
import 'package:echoemaar_commerce/core/network/odoo_http_client.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/address_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/country_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/country_state_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/order_confirmation_model.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order_confirmation.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/payment_method.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/shipping_address.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/pages/order_success_page.dart';
import 'package:injectable/injectable.dart';

// features/checkout/data/datasources/checkout_remote_data_source.dart
abstract class CheckoutRemoteDataSource {
  // --- Address Management ---
  Future<ShippingAddressModel> getAddresses();
    Future<List<CountryModel>> getcountries();
    Future<List<CountryStateModel>> getCountryStates(int country);

  Future<ShippingAddressModel> addAddress(ShippingAddressModel address);
  Future<ShippingAddressModel> updateAddress(ShippingAddressModel address); // Added
  Future<void> deleteAddress(int addressId); // Added

  // --- Order Management ---
  Future<OrderSummary> getOrderSummary({
    required int cartId, 
    required int addressId, 
    required String paymentMethod, 
    String? notes
  });
  
  Future<OrderConfirmation> confirmOrder(int summaryId); // Added (replaces/augments placeOrder)
  
  // --- Payment & Fees ---
  Future<double> getShippingFee(int addressId); // Added
  Future<bool> validatePayment(int orderId); // Added
  
  // Legacy/Simplified helpers (Optional)
  Future<int> placeOrder(int cartId, int addressId);
  Future<bool> processPayment(int orderId, String paymentMethod);
}
class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final OdooHttpClient apiClient;

  CheckoutRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> deleteAddress(int addressId) async {
  
    // TODO: implement getAddresses
    throw UnimplementedError();
  }

  @override
  Future<OrderSummary> getOrderSummary({
    required int cartId,
    required int addressId,
    required String paymentMethod,
    String? notes,
  }) async {
   
    // TODO: implement getAddresses
    throw UnimplementedError();
  }

  @override
  Future<OrderConfirmation> confirmOrder(int summaryId) async {

  var result = await apiClient.restPost(ApiConstants.placeOrderEndpoint, 
   body: { "order_id" : summaryId}
   
   );
   return OrderConfirmationModel.fromJson(result['order']);
  }

  @override
  Future<double> getShippingFee(int addressId) async {
 
    // TODO: implement getAddresses
    throw UnimplementedError();
  }

  @override
  Future<bool> validatePayment(int orderId) async {
   
    // TODO: implement getAddresses
    throw UnimplementedError();
  }
  
  @override
  Future<ShippingAddressModel> addAddress(ShippingAddressModel address)async {
    var result = await apiClient.restPost(ApiConstants.updateAddressEndpoint, body: address.toJson());
    return result['data'].map<ShippingAddressModel>((data) => ShippingAddressModel.fromJson(data));

  }
  
  @override
  Future<ShippingAddressModel> getAddresses()async {
   var result = await apiClient.restGet(ApiConstants.getAddressEnpoint,);
   log("ADDRESS: $result");
    return  ShippingAddressModel.fromJson(result['partner info']);

  }
  
  @override
  Future<int> placeOrder(int cartId, int addressId) {
    // TODO: implement placeOrder
    throw UnimplementedError();
  }
  
  @override
  Future<bool> processPayment(int orderId, String paymentMethod) {
    // TODO: implement processPayment
    throw UnimplementedError();
  }
  
  @override
  Future<ShippingAddressModel> updateAddress(ShippingAddressModel address)async {
    
    var result = await apiClient.restPost(ApiConstants.updateAddressEndpoint, body: address.toJson());
    return result['data'].map<ShippingAddressModel>((data) => ShippingAddressModel.fromJson(data));


  }
  
  @override
  Future<List<CountryModel>> getcountries()async {  // final domain = <dynamic>[
    //   ['sale_ok', '=', true],
    //   ['active', '=', true],
    // ];
    
    // if (categoryId != null) {
    //   domain.add(['categ_id', '=', categoryId]);
    // }
    
    final result = await apiClient.restGet(
      ApiConstants.getCountriesEnpoint
      // 'product.product',
      // domain: domain,
      // fields: [
      //   'id',
      //   'name',
      //   'description_sale',
      //   'list_price',
      //   'sale_price',
      //   'categ_id',
      //   'qty_available',
      //   'image_1920',
      //   'product_image_ids',
      //   'rating_avg',
      //   'rating_count',
      // ],
      // offset: offset,
      // limit: limit,
      // order: sortBy ?? 'id desc',
    );
    
    return result['countries'].map<CountryModel>((data) => CountryModel.fromJson(data)).toList();
  }
  
  @override
  Future<List<CountryStateModel>> getCountryStates(int country) async{ 
     final result = await apiClient.restGet(
      "${ApiConstants.getStatesEndpoint}$country/states"
      // 'product.product',
      // domain: domain,
      // fields: [
      //   'id',
      //   'name',
      //   'description_sale',
      //   'list_price',
      //   'sale_price',
      //   'categ_id',
      //   'qty_available',
      //   'image_1920',
      //   'product_image_ids',
      //   'rating_avg',
      //   'rating_count',
      // ],
      // offset: offset,
      // limit: limit,
      // order: sortBy ?? 'id desc',
    );
    
    return result['states'].map<CountryStateModel>((data) => CountryStateModel.fromJson(data)).toList();
  }

  // ... (Other existing methods)
}