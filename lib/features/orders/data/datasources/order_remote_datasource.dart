import 'dart:convert';

import 'package:echoemaar_commerce/config/constants/api_constants.dart';
import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import 'package:echoemaar_commerce/core/network/odoo_http_client.dart';
import 'package:echoemaar_commerce/features/auth/data/models/user_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/order_details_model.dart';
import 'package:echoemaar_commerce/features/orders/data/models/order_history_model.dart';

import '../../../../core/network/odoo_api_client.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithPhone(String phone, String password);
  Future<String> sendOtp(String phone);
  Future<UserModel> verifyOtp(String phone, String otp);
  Future<UserModel> register(String name, String email, String phone, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final OdooApiClient odooClient;
  
  AuthRemoteDataSourceImpl({required this.odooClient});
  
  @override
  Future<UserModel> loginWithPhone(String phone, String password) async {
    // Authenticate with Odoo
    await odooClient.authenticate('your_database', phone, password);
    
    // Fetch user details
    final result = await odooClient.searchRead(
      'res.partner',
      domain: [['phone', '=', phone]],
      fields: ['id', 'name', 'email', 'phone', 'image_128'],
      limit: 1,
    );
    
    if (result.isEmpty) {
      throw Exception('User not found');
    }
    
    return UserModel.fromOdoo(result[0]);
  }
  
  @override
  Future<String> sendOtp(String phone) async {
    // Implement OTP sending logic
    // This could be through Odoo or a separate SMS service
    final result = await odooClient.create('sms.otp', {
      'phone': phone,
    });
    
    return 'OTP sent successfully';
  }
  
  @override
  Future<UserModel> verifyOtp(String phone, String otp) async {
    // Verify OTP through Odoo
    final result = await odooClient.searchRead(
      'sms.otp',
      domain: [
        ['phone', '=', phone],
        ['otp', '=', otp],
        ['is_verified', '=', false],
      ],
      limit: 1,
    );
    
    if (result.isEmpty) {
      throw Exception('Invalid OTP');
    }
    
    // Mark as verified
    await odooClient.write('sms.otp', result[0]['id'], {'is_verified': true});
    
    // Fetch user
    final userResult = await odooClient.searchRead(
      'res.partner',
      domain: [['phone', '=', phone]],
      fields: ['id', 'name', 'email', 'phone', 'image_128'],
      limit: 1,
    );
    
    return UserModel.fromOdoo(userResult[0]);
  }
  
  @override
  Future<UserModel> register(String name, String email, String phone, String password) async {
    final userId = await odooClient.create('res.partner', {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    });
    
    final result = await odooClient.searchRead(
      'res.partner',
      domain: [['id', '=', userId]],
      fields: ['id', 'name', 'email', 'phone', 'image_128'],
      limit: 1,
    );
    
    return UserModel.fromOdoo(result[0]);
  }
}





class OrderRemoteDataSource {
  final OdooHttpClient apiClient;
  OrderRemoteDataSource({required this.apiClient});

  Future<List<OrderModel>> getOrders({String state = 'sale'}) async {
    final response = await apiClient.restPost(ApiConstants.allOrdersEndpoint ,body:
    
    state.isEmpty?{}:
     {
      'state':state.isEmpty?'': state
    });
    

      final List data = response['result']['orders'] as List;
      return data.map((item) => OrderModel.fromJson(item)).toList();
   
  }
Future<OrderDetailModel> getOrderDetails(int order) async {
    final response = await apiClient.restGet(ApiConstants.orderDetailsEndpoint+"$order");
    

      // final List data = response['order'] ;
      return  OrderDetailModel.fromJson(response['order']);
   
  }

}