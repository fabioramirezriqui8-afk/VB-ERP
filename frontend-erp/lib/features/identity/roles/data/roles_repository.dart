import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/env.dart';
import '../../auth/data/auth_storage.dart';
import '../domain/role_model.dart';

class RolesRepository {
  RolesRepository({http.Client? client, AuthStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? AuthStorage();

  final http.Client _client;
  final AuthStorage _storage;

  Future<Map<String, String>> _headers() async {
    final tokens = await _storage.load();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokens?.accessToken}',
    };
  }

  Future<List<RolModel>> listRoles() async {
    final url = Uri.parse('${Env.apiBaseUrl}/api/v1/roles');
    final response = await _client.get(url, headers: await _headers());

    if (response.statusCode != 200) {
      throw Exception('Failed to load roles: ${response.body}');
    }

    final body = jsonDecode(response.body);
    if (body['success'] != true) {
      throw Exception('API error: ${body['message'] ?? response.body}');
    }

    final data = body['data'];
    if (data == null || data is! Map) return [];

    final itemsJson = data['items'];
    if (itemsJson == null || itemsJson is! List) return [];

    final result = <RolModel>[];
    for (var j in itemsJson) {
      try {
        result.add(RolModel.fromJson(j as Map<String, dynamic>));
      } catch (e) {
        print('Error parsing role record: $e');
      }
    }
    return result;
  }
}
