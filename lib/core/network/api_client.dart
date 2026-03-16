import 'dart:convert';
import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;
  final Duration timeout;
  
  ApiClient({
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
      final uri = _buildUri(url, queryParameters);
      
      final response = await _client
          .post(
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
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    // Handle error responses
    String errorMessage = 'Request failed with status: ${response.statusCode}';
    
    try {
      final errorBody = jsonDecode(response.body);
      if (errorBody is Map && errorBody.containsKey('error')) {
        errorMessage = errorBody['error']['message'] ?? errorMessage;
      } else if (errorBody is Map && errorBody.containsKey('message')) {
        errorMessage = errorBody['message'];
      }
    } catch (_) {
      errorMessage = response.body.isNotEmpty 
          ? response.body 
          : errorMessage;
    }
    
    throw ServerException(errorMessage);
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