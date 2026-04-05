import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/auth_model.dart';
import 'auth_dto.dart';

/// Persistencia local del token — separada del repositorio
class AuthStorage {
  static const _keyTokens = 'auth_tokens';

  Future<void> save(AuthTokens tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTokens, jsonEncode({
      'access_token':  tokens.accessToken,
      'refresh_token': tokens.refreshToken,
      'user': {
        'id':          tokens.user.id,
        'name':        tokens.user.name,
        'email':       tokens.user.email,
        'roles':       tokens.user.roles,
        'permissions': tokens.user.permissions,
      },
    }));
  }

  Future<AuthTokens?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString(_keyTokens);
    if (raw == null) return null;
    try {
      return AuthResponseDto.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      ).toDomain();
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTokens);
  }
}
