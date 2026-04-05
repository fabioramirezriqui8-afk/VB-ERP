import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/env.dart';
import '../../auth/data/auth_storage.dart';
import '../domain/user_model.dart';

class UsersRepository {
  UsersRepository({http.Client? client, AuthStorage? storage})
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

  Future<List<UsuarioModel>> listUsers({int page = 1, int limit = 20}) async {
    final url = Uri.parse('${Env.apiBaseUrl}/api/v1/users?page=$page&limit=$limit');
    final response = await _client.get(url, headers: await _headers());

    if (response.statusCode != 200) {
      throw Exception('Failed to load users: ${response.body}');
    }

    final body = jsonDecode(response.body);
    final data = body['data'] ?? {};
    final List items = data['items'] ?? [];

    return items.map((json) => UsuarioModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String roleId,
  }) async {
    final url = Uri.parse('${Env.apiBaseUrl}/api/v1/users');
    final response = await _client.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'name':     name,
        'email':    email,
        'password': password,
        'role_id':  roleId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user: ${response.body}');
    }
  }
}
