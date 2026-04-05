/// Entidad de dominio — no sabe nada de JSON ni de HTTP
class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.permissions,
  });

  final String id;
  final String name;
  final String email;
  final List<String> roles;
  final List<String> permissions;

  bool hasPermission(String permission) => permissions.contains(permission);
  bool hasRole(String role) => roles.contains(role);
}

class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final AuthUser user;
}
