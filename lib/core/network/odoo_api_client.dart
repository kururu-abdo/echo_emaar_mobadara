import 'package:odoo_rpc/odoo_rpc.dart';

class OdooApiClient {
  final OdooClient _client;
  
  OdooApiClient(this._client);
  
  Future<void> authenticate(String database, String login, String password) async {
    await _client.authenticate(database, login, password);
  }
  
  Future<dynamic> searchRead(
    String model, {
    List<dynamic>? domain,
    List<String>? fields,
    int offset = 0,
    int limit = 0,
    String? order,
  }) async {
    return await _client.callKw({
      'model': model,
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'domain': domain ?? [],
        'fields': fields ?? [],
        'offset': offset,
        'limit': limit,
        'order': order,
      },
    });
  }
  
  Future<dynamic> create(String model, Map<String, dynamic> values) async {
    return await _client.callKw({
      'model': model,
      'method': 'create',
      'args': [values],
      'kwargs': {},
    });
  }
  
  Future<dynamic> write(String model, int id, Map<String, dynamic> values) async {
    return await _client.callKw({
      'model': model,
      'method': 'write',
      'args': [
        [id],
        values,
      ],
      'kwargs': {},
    });
  }
  
  Future<bool> unlink(String model, int id) async {
    return await _client.callKw({
      'model': model,
      'method': 'unlink',
      'args': [
        [id]
      ],
      'kwargs': {},
    });
  }
}