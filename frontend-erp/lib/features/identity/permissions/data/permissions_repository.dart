import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/env.dart';
import '../../auth/data/auth_storage.dart';
import '../domain/permission_model.dart';

/// Solo HTTP — sin definir modelos
class PermissionsRepository {
  PermissionsRepository({http.Client? client, AuthStorage? storage})
      : _client  = client  ?? http.Client(),
        _storage = storage ?? AuthStorage();

  final http.Client  _client;
  final AuthStorage  _storage;

  Future<Map<String, String>> _headers() async {
    final tokens = await _storage.load();
    return {
      'Content-Type':  'application/json',
      'Authorization': 'Bearer ${tokens?.accessToken}',
    };
  }

  Future<List<PermissionModel>> listPermissions() async {
    final res = await _client.get(
      Uri.parse('${Env.apiBaseUrl}/api/v1/permissions'),
      headers: await _headers(),
    );
    if (res.statusCode != 200) {
      throw Exception('Error cargando permisos: ${res.body}');
    }
    final body = jsonDecode(res.body);
    if (body['success'] != true) {
      throw Exception('API error: ${body['message'] ?? res.body}');
    }

    final data = body['data'];
    if (data == null || data is! List) return [];

    final result = <PermissionModel>[];
    for (var j in data) {
      try {
        result.add(PermissionModel.fromJson(j as Map<String, dynamic>));
      } catch (e) {
        print('Error parsing permission: $e');
      }
    }
    return result;
  }
}
