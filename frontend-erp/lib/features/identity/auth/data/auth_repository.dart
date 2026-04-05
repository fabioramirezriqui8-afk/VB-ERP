import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/auth_model.dart';
import '../domain/i_auth_repository.dart';
import 'auth_dto.dart';
import 'auth_storage.dart';

/// Implementación HTTP — solo sabe de red y storage, no de UI
class AuthRepository implements IAuthRepository {
  AuthRepository({required this.baseUrl, required this.storage});

  final String baseUrl;
  final AuthStorage storage;

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(LoginRequestDto(email: email, password: password).toJson()),
    );

    if (res.statusCode != 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      throw AuthException(body['error'] as String? ?? 'Error de autenticación');
    }

    final data    = jsonDecode(res.body)['data'] as Map<String, dynamic>;
    final tokens  = AuthResponseDto.fromJson(data).toDomain();

    await storage.save(tokens);
    return tokens;
  }

  @override
  Future<void> logout() => storage.clear();

  @override
  Future<AuthTokens?> restoreSession() => storage.load();
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
