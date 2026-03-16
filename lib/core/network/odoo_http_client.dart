import 'dart:convert';
import 'dart:developer';
import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'http_client.dart';

class OdooHttpClient {
  final String baseUrl;
  final String database;
  final AppHttpClient httpClient;
  final SessionProvider getSession;
    final SharedPreferences _prefs;
  String? _sessionId;
  int? _uid;
  String? _password;
  
  OdooHttpClient({
    required this.getSession,
    required this.baseUrl,
    required this.database,
     required SharedPreferences prefs,
    AppHttpClient? httpClient,
    //  required SharedPreferences prefs,
  }) 
  
  : _prefs = prefs,
   httpClient = httpClient ?? AppHttpClient(getSession: getSession);
  
  bool get isAuthenticated => _sessionId != null && _uid != null;
  
  String get _jsonRpcUrl => '$baseUrl/jsonrpc';
  String get _webUrl => '$baseUrl/web';
  String get _apiUrl => baseUrl;
  
  // ==================== AUTHENTICATION ====================
  
  /// Authenticate with Odoo (RPC)
  Future<Map<String, dynamic>> authenticate({
    required String login,
    required String password,
  }) async {
    try {
      final response = await _callRPC(
        '/web/session/authenticate',
        {
          'db': database,
          'login': login,
          'password': password,
        },
      );
      
      if (response['result'] != null) {
        final result = response['result'];
        _uid = result['uid'];
        _sessionId = result['session_id'];
        _password = password;
        
        return {
          'uid': _uid,
          'session_id': _sessionId,
          'username': result['username'],
          'name': result['name'],
          'partner_id': result['partner_id'],
        };
      }
      
      throw ServerException('Authentication failed');
    } catch (e) {
      throw ServerException('Authentication error: $e');
    }
  }
  
  /// Get session info
  Future<Map<String, dynamic>> getSessionInfo() async {
    return await _callRPC('/web/session/get_session_info', {});
  }
  
  /// Logout
  Future<void> logout() async {
    await _callRPC('/web/session/destroy', {});
    _sessionId = null;
    _uid = null;
    _password = null;
  }
  
  // ==================== RPC METHODS ====================
  
  /// Call Odoo RPC method
  Future<Map<String, dynamic>> _callRPC(
    String endpoint,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await httpClient.post(
        '$baseUrl$endpoint',
        headers: _buildHeaders(),
        body: {
          'jsonrpc': '2.0',
          'method': 'call',
          'params': params,
          'id': DateTime.now().millisecondsSinceEpoch,
        },
      );
    
      if (response.containsKey('error')) {
        final error = response['error'];
        throw ServerException(
          error['message'] ?? error['data']?['message'] ?? 'RPC Error',
        );
      }
      
      return response;
    } catch (e) {
      throw ServerException('RPC call failed: $e');
    }
  }
  
  /// Call Odoo model method (ORM)
  Future<dynamic> callKw({
    required String model,
    required String method,
    List<dynamic>? args,
    Map<String, dynamic>? kwargs,
  }) async {
    _ensureAuthenticated();
    
    final response = await _callRPC(
      '/web/dataset/call_kw',
      {
        'model': model,
        'method': method,
        'args': args ?? [],
        'kwargs': kwargs ?? {},
      },
    );
    
    return response['result'];
  }
  
  // ==================== CRUD OPERATIONS (RPC) ====================
  
  /// Search for records
  Future<List<int>> search(
    String model, {
    List<dynamic>? domain,
    int offset = 0,
    int limit = 0,
    String? order,
  }) async {
    final result = await callKw(
      model: model,
      method: 'search',
      args: [domain ?? []],
      kwargs: {
        'offset': offset,
        'limit': limit,
        'order': order ?? 'id desc',
      },
    );
    
    return (result as List).cast<int>();
  }
  
  /// Search and read records
  Future<List<dynamic>> searchRead(
    String model, {
    List<dynamic>? domain,
    List<String>? fields,
    int offset = 0,
    int limit = 0,
    String? order,
  }) async {
    final result = await callKw(
      model: model,
      method: 'search_read',
      kwargs: {
        'domain': domain ?? [],
        'fields': fields ?? [],
        'offset': offset,
        'limit': limit,
        'order': order ?? 'id desc',
      },
    );
    
    return result as List<dynamic>;
  }
  
  /// Read records by IDs
  Future<List<dynamic>> read(
    String model,
    List<int> ids, {
    List<String>? fields,
  }) async {
    final result = await callKw(
      model: model,
      method: 'read',
      args: [ids],
      kwargs: {
        'fields': fields ?? [],
      },
    );
    
    return result as List<dynamic>;
  }
  
  /// Create a record
  Future<int> create(
    String model,
    Map<String, dynamic> values,
  ) async {
    final result = await callKw(
      model: model,
      method: 'create',
      args: [values],
    );
    
    return result as int;
  }
  
  /// Update records
  Future<bool> write(
    String model,
    List<int> ids,
    Map<String, dynamic> values,
  ) async {
    final result = await callKw(
      model: model,
      method: 'write',
      args: [ids, values],
    );
    
    return result as bool;
  }
  
  /// Delete records
  Future<bool> unlink(
    String model,
    List<int> ids,
  ) async {
    final result = await callKw(
      model: model,
      method: 'unlink',
      args: [ids],
    );
    
    return result as bool;
  }
  
  /// Count records
  Future<int> searchCount(
    String model, {
    List<dynamic>? domain,
  }) async {
    final result = await callKw(
      model: model,
      method: 'search_count',
      args: [domain ?? []],
    );
    
    return result as int;
  }
  
  /// Get fields definition
  Future<Map<String, dynamic>> fieldsGet(
    String model, {
    List<String>? fields,
  }) async {
    final result = await callKw(
      model: model,
      method: 'fields_get',
      kwargs: {
        'attributes': ['string', 'type', 'required', 'readonly'],
        if (fields != null) 'allfields': fields,
      },
    );
    
    return result as Map<String, dynamic>;
  }
  
  /// Check access rights
  Future<bool> checkAccessRights(
    String model,
    String operation, {
    bool raiseException = false,
  }) async {
    final result = await callKw(
      model: model,
      method: 'check_access_rights',
      args: [operation, raiseException],
    );
    
    return result as bool;
  }
  
  // ==================== REST API METHODS ====================
  
  /// GET request to Odoo REST API
  Future<Map<String, dynamic>> restGet(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    // _ensureAuthenticated();
    log(_buildHeaders().toString());
    return await httpClient.get(
      '$_apiUrl$endpoint',
      headers: _buildHeaders(),
      queryParameters: queryParameters,
    );
  }
  
  /// POST request to Odoo REST API
  Future<Map<String, dynamic>> restPost(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    // _ensureAuthenticated();
    log(body.toString());
    return await httpClient.post(
      '$_apiUrl$endpoint',
      headers:{... _buildHeaders()
    
      
      },
      body: body,
      
    );
  }
  
  /// PUT request to Odoo REST API
  Future<Map<String, dynamic>> restPut(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    _ensureAuthenticated();
    
    return await httpClient.put(
      '$_apiUrl$endpoint',
      headers: _buildHeaders(),
      body: body,
    );
  }
  
  /// PATCH request to Odoo REST API
  Future<Map<String, dynamic>> restPatch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    _ensureAuthenticated();
    
    return await httpClient.patch(
      '$_apiUrl$endpoint',
      headers: _buildHeaders(),
      body: body,
    );
  }
  
  /// DELETE request to Odoo REST API
  Future<Map<String, dynamic>> restDelete(
    String endpoint,
  ) async {
    _ensureAuthenticated();
    
    return await httpClient.delete(
      '$_apiUrl$endpoint',
      headers: _buildHeaders(),
    );
  }
  
  // ==================== SPECIAL OPERATIONS ====================
  
  /// Execute workflow
  Future<dynamic> execWorkflow(
    String model,
    String signal,
    int id,
  ) async {
    return await callKw(
      model: model,
      method: 'signal_workflow',
      args: [id, signal],
    );
  }
  
  /// Call button action
  Future<dynamic> buttonAction(
    String model,
    String button,
    List<int> ids,
  ) async {
    return await callKw(
      model: model,
      method: button,
      args: [ids],
    );
  }
  
  /// Get server version
  Future<Map<String, dynamic>> getServerVersion() async {
    final response = await httpClient.post(
      '$baseUrl/web/webclient/version_info',
      headers: _buildHeaders(),
      body: {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {},
        'id': DateTime.now().millisecondsSinceEpoch,
      },
    );
    
    return response['result'] as Map<String, dynamic>;
  }
  
  /// Download file/report
  Future<List<int>> downloadFile(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$url'),
      headers: {..._buildHeaders(), ...?headers},
    );
    
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    
    throw ServerException('File download failed: ${response.statusCode}');
  }
  
  /// Upload file
  Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    String filePath,
    List<int> fileBytes, {
    Map<String, String>? fields,
  }) async {
    _ensureAuthenticated();
    
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$endpoint'),
    );
    
    request.headers.addAll(_buildHeaders());
    
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: filePath.split('/').last,
      ),
    );
    
    if (fields != null) {
      request.fields.addAll(fields);
    }
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    throw ServerException('File upload failed: ${response.statusCode}');
  }
  
  // ==================== HELPER METHODS ====================
  
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    log(getAuthToken().toString());
    if (getAuthToken() != null) {
      headers['Cookie'] = 'session_id=${getAuthToken()}';
    }
    
    return headers;
  }
  
  void _ensureAuthenticated() {
    if (!isAuthenticated) {
      throw ServerException('Not authenticated. Please login first.');
    }
  }
  
  void dispose() {
    httpClient.dispose();
  }
 String?  getAuthToken()  {

    _sessionId= _prefs.getString('AUTH_TOKEN');
    return _sessionId;
  }
  
  @override
  Future<void> saveAuthToken(String token) async {
        var sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('AUTH_TOKEN', token);
  }
}