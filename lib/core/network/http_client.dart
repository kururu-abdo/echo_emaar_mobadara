import 'dart:convert';
import 'dart:developer';
import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
typedef SessionProvider = Future<String?> Function();
class AppHttpClient {
  final http.Client _client;
  final Duration timeout;
  final SessionProvider getSession;
  AppHttpClient({
    required this.getSession,
    http.Client? client,
    this.timeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client();
  
  /// GET Request
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(url, queryParameters);
      
      final response = await _client
          .get(uri, headers: _buildHeaders(headers))
          .timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw ServerException(_handleError(e));
    }
  }
  
  /// POST Request
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      log(url);
      final uri = _buildUri(url, queryParameters);
      log(body.toString());
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);
          _extractSessionId(response);
      return _handleResponse(response);
    } catch (e) {
      log(e.toString());
      throw ServerException(_handleError(e));
    }
  }
  


  void _extractSessionId(http.Response response) {
  // Odoo returns 'set-cookie' which usually contains session_id=...
  final String? rawCookie = response.headers['set-cookie'];
  if (rawCookie != null) {
    // Regular expression to find the session_id value
    final regExp = RegExp(r'session_id=([^;]+)');
    final match = regExp.firstMatch(rawCookie);
    // return
    saveAuthToken(  match?.group(1).toString());
   
  }
  return;
}

 Future<void> saveAuthToken(String? token) async {
        var sharedPreferences = await SharedPreferences.getInstance();
if (token == null) {
  return;
}
    await sharedPreferences.setString('AUTH_TOKEN', token??'');
  }
  /// PUT Request
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(url, queryParameters);
      
      final response = await _client
          .put(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw ServerException(_handleError(e));
    }
  }
  
  /// PATCH Request
  Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(url, queryParameters);
      
      final response = await _client
          .patch(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw ServerException(_handleError(e));
    }
  }
  
  /// DELETE Request
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(url, queryParameters);
      
      final response = await _client
          .delete(uri, headers: _buildHeaders(headers))
          .timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw ServerException(_handleError(e));
    }
  }
  
  /// Build URI with query parameters
  Uri _buildUri(String url, Map<String, dynamic>? queryParameters) {
    final uri = Uri.parse(url);
    
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final params = queryParameters.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      return uri.replace(queryParameters: params);
    }
    
    return uri;
  }
  
  /// Build headers with default content type
  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };
  }
  
  /// Handle HTTP response
  /// 
  /// 
  /// 
  /*
 Map<String, dynamic> _handleResponse(http.Response response) {
  log('RESPONSE STATUS CODE: ${response.statusCode}');

  // 1. Check for standard HTTP errors (non-200/201)
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw ServerException('Server error: ${response.statusCode}');
  }

  // 2. Handle empty body
  if (response.body.isEmpty) {
    return {'success': true};
  }

  final Map<String, dynamic> decodedBody = jsonDecode(response.body);
  
  // 3. Navigate the JSON-RPC "result" wrapper
  // if (!decodedBody.containsKey('result')) {
  //   throw ServerException('Invalid response format: Missing "result" field');
  // }

  final result = (decodedBody['result']?? decodedBody);

  // 4. Check the business logic 'success' flag (Inside the 200 OK)
  final bool success = result['success'] ?? false;

  if (success) {
    // Return the "data" portion (The user profile info)
    return 
    
    
    result['data'];
  } else {
    // If success is false, extract the error message
    // Structure: {"success": false, "error": "...", "message": "..."}
    final String errorMessage = result['message'] ?? result['error'] ?? 'Unknown error';
    log('BUSINESS LOGIC ERROR: $errorMessage');
    throw ServerException(errorMessage);
  }
}
  */

  dynamic _handleResponse(http.Response response) {
  log('RESPONSE STATUS CODE: ${response.body}');

  // 1. Basic HTTP Status Check
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw ServerException('Server error: ${response.statusCode}');
  }

  if (response.body.isEmpty) {
    return {'success': true};
  }

  final Map<String, dynamic> decodedBody = jsonDecode(response.body);
log("REMOTE BODY:   $decodedBody");
  // 2. Check the "success" flag at the root
  final bool success = decodedBody['success'] ??  decodedBody['result']?['success'] ?? (decodedBody['result']['status'].toString()=='success')   ?? false;
log(success.toString());
  if (success) {
    log('SuCCESS ${decodedBody.runtimeType}');
    // 3. Return the data (could be a Map for Auth or a List for Products)
    // Based on your new pattern, your products are in 'data'
    return decodedBody; 
  } else {
    // Extract error from the new pattern
    final String errorMessage = decodedBody['message'] ?? 
                                decodedBody['error'] ?? 
                                'Operation failed on server';
    log('API BUSINESS ERROR: $errorMessage');
    throw ServerException(errorMessage);
  }
}
  
  /// Handle errors
  String _handleError(dynamic error) {
    if (error is ServerException) {
      return error.message;
    }
    return error.toString();
  }
  
  /// Close client
  void dispose() {
    _client.close();
  }
}