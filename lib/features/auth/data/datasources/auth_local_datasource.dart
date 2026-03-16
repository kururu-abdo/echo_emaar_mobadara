import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<String?> getAuthToken();
  Future<void> saveAuthToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const String cachedUserKey = 'CACHED_USER';
  static const String authTokenKey = 'AUTH_TOKEN';
  
  AuthLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(cachedUserKey);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user');
    }
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = json.encode(user.toJson());
      await sharedPreferences.setString(cachedUserKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache user');
    }
  }
  
  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(cachedUserKey);
      await sharedPreferences.remove(authTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear cache');
    }
  }
  
  @override
  Future<String?> getAuthToken() async {
    return sharedPreferences.getString(authTokenKey);
  }
  
  @override
  Future<void> saveAuthToken(String token) async {
    await sharedPreferences.setString(authTokenKey, token);
  }
}