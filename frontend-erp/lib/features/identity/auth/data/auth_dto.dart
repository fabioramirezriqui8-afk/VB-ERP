import '../domain/auth_model.dart';

/// DTOs — solo saben de JSON, no de UI ni de dominio
class LoginRequestDto {
  const LoginRequestDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  final String email;
  final String password;
}

class AuthUserDto {
  const AuthUserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.permissions,
  });

  factory AuthUserDto.fromJson(Map<String, dynamic> j) => AuthUserDto(
        id:          j['id'] as String,
        name:        j['name'] as String,
        email:       j['email'] as String,
        roles:       List<String>.from(j['roles'] as List),
        permissions: List<String>.from(j['permissions'] as List),
      );

  final String id;
  final String name;
  final String email;
  final List<String> roles;
  final List<String> permissions;

  AuthUser toDomain() => AuthUser(
        id:          id,
        name:        name,
        email:       email,
        roles:       roles,
        permissions: permissions,
      );
}

class AuthResponseDto {
  const AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> j) => AuthResponseDto(
        accessToken:  j['access_token'] as String,
        refreshToken: j['refresh_token'] as String,
        user:         AuthUserDto.fromJson(j['user'] as Map<String, dynamic>),
      );

  final String accessToken;
  final String refreshToken;
  final AuthUserDto user;

  AuthTokens toDomain() => AuthTokens(
        accessToken:  accessToken,
        refreshToken: refreshToken,
        user:         user.toDomain(),
      );
}
