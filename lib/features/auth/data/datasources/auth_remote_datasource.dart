import 'dart:developer';

import 'package:echoemaar_commerce/config/constants/api_constants.dart';
import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import 'package:echoemaar_commerce/core/network/odoo_http_client.dart';

import '../../../../core/network/odoo_api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String name,
    required String email,
    required String password ,
  });
  
  Future<String> sendOtp(String phoneNumber);
  Future<UserModel> verifyOtp(String phoneNumber, String otp);
  Future<bool> checkPhoneExists(String phoneNumber);
    Future<UserModel> loginWithEmail(String email , String password);

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final OdooHttpClient odooClient;
  
  AuthRemoteDataSourceImpl({required this.odooClient});
  
  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Check if phone number already exists
      // final exists = await checkPhoneExists(phoneNumber);
      // if (exists) {
      //   throw ServerException('Phone number already registered');
      // }
      
      // Check if email already exists
      final result = await odooClient.restPost(
       ApiConstants.registerEndpoint,
     body:    {
'email': email, 
'password': password, 
'confirm_password':password, 
'name': name

        }
      );
      
      // if (emailCheck.isNotEmpty) {
      //   throw ServerException('Email already registered');
      // }
    /*
      // Create new user/partner
      final userId = await odooClient.create('res.partner', {
        'name': name,
        'email': email,
        // 'phone': phoneNumber,
        // 'mobile': phoneNumber,
        // 'country_code': countryCode,
        'phone_verified': false,
        'customer_rank': 1, // Mark as customer
      });
      
      // Fetch created user
      final result = await odooClient.searchRead(
        'res.partner',
        domain: [['id', '=', userId]],
        fields: [
          'id',
          'name',
          'email',
          'phone',
          'mobile',
          'image_128',
          'create_date',
          'phone_verified',
          'country_code',
        ],
        limit: 1,
      );
      
      if (result.isEmpty) {
        throw ServerException('Failed to create user');
      }
      */
      log("TEST REGISTERATION. $result");
      return UserModel.fromOdoo(result);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<String> sendOtp(String phoneNumber) async {
    try {
      // Check if user exists
      final userResult = await odooClient.searchRead(
        'res.partner',
        domain: [
          '|',
          ['phone', '=', phoneNumber],
          ['mobile', '=', phoneNumber],
        ],
        fields: ['id', 'name'],
        limit: 1,
      );
      
      if (userResult.isEmpty) {
        throw ServerException('Phone number not registered');
      }
      
      final userId = userResult[0]['id'] as int;
      
      // Generate 6-digit OTP
      final otp = _generateOtp();
      
      // Store OTP in database (assuming you have an otp.verification model in Odoo)
      await odooClient.create('otp.verification', {
        'partner_id': userId,
        'phone': phoneNumber,
        'otp_code': otp,
        'is_verified': false,
        'expires_at': DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
      });
      
      // In production, send actual SMS here
      // For development, return the OTP (REMOVE IN PRODUCTION!)
      print('🔐 OTP for $phoneNumber: $otp'); // Development only
      
      return 'OTP sent successfully';
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<UserModel> verifyOtp(String phoneNumber, String otp) async {
    try {
      // Find OTP record
      final otpResult = await odooClient.searchRead(
        'otp.verification',
        domain: [
          ['phone', '=', phoneNumber],
          ['otp_code', '=', otp],
          ['is_verified', '=', false],
        ],
        fields: ['id', 'partner_id', 'expires_at'],
        limit: 1,
        order: 'id desc',
      );
      
      if (otpResult.isEmpty) {
        throw ServerException('Invalid or expired OTP');
      }
      
      final otpRecord = otpResult[0];
      final expiresAt = DateTime.parse(otpRecord['expires_at']);
      
      // Check if OTP is expired
      if (DateTime.now().isAfter(expiresAt)) {
        throw ServerException('OTP has expired. Please request a new one.');
      }
      
      final partnerId = otpRecord['partner_id'] is List
          ? otpRecord['partner_id'][0] as int
          : otpRecord['partner_id'] as int;
      
      // Mark OTP as verified
      await odooClient.write('otp.verification', otpRecord['id'], {
        'is_verified': true,
      });
      
      // Update partner phone_verified status
      // await odooClient.write('res.partner', partnerId, {
      //   'phone_verified': true,
      // });
      
      // Fetch user details
      final userResult = await odooClient.searchRead(
        'res.partner',
        domain: [['id', '=', partnerId]],
        fields: [
          'id',
          'name',
          'email',
          'phone',
          'mobile',
          'image_128',
          'create_date',
          'phone_verified',
          'country_code',
        ],
        limit: 1,
      );
      
      if (userResult.isEmpty) {
        throw ServerException('User not found');
      }
      
      return UserModel.fromOdoo(userResult[0]);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<bool> checkPhoneExists(String phoneNumber) async {
    try {
      final result = await odooClient.searchRead(
        'res.partner',
        domain: [
          '|',
          ['phone', '=', phoneNumber],
          ['mobile', '=', phoneNumber],
        ],
        fields: ['id'],
        limit: 1,
      );
      
      return result.isNotEmpty;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  String _generateOtp() {
    return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
  }
  
  @override
  Future<UserModel> loginWithEmail(String email, String password)async {
    // TODO: implement loginWithEmail
 var result = await  odooClient.restPost(ApiConstants.loginEndpoint, 
 body: {
  'email': email, 
  'password': password
 },

 
 );
log("TEST LOGIN. $result  ");

 return UserModel.fromJson(result['result']['data']);
  }
}