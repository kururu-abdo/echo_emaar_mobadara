import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _authTokenKey = 'auth_token';
  
  final SharedPreferences prefs;
  
  CacheHelper(this.prefs);
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  
  // Set logged in status
  Future<void> setLoggedIn(bool value) async {
    await prefs.setBool(_isLoggedInKey, value);
  }
  
  // Get user ID
  Future<int?> getUserId() async {
    return prefs.getInt(_userIdKey);
  }
  
  // Save user ID
  Future<void> saveUserId(int userId) async {
    await prefs.setInt(_userIdKey, userId);
  }
  
  // Get auth token
  Future<String?> getAuthToken() async {
    return prefs.getString(_authTokenKey);
  }
  
  // Save auth token
  Future<void> saveAuthToken(String token) async {
    await prefs.setString(_authTokenKey, token);
  }
  
  // Clear all auth data
  Future<void> clearAuthData() async {
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_authTokenKey);
  }
}