import '../domain/auth_model.dart';
import '../domain/i_auth_repository.dart';

/// Repositorio falso para desarrollo — no necesita backend
class AuthMockRepository implements IAuthRepository {
  // Usuarios de prueba
  static const _users = [
    (
      email: 'admin@vb-erp.com',
      password: 'Admin1234',
      name: 'Super Administrador',
      roles: ['super_admin'],
      permissions: [
        'identity:users:read', 'identity:users:create', 'identity:users:update', 'identity:users:delete',
        'identity:roles:read', 'identity:roles:manage', 'identity:permissions:read',
        'inventory:products:read', 'inventory:products:create', 'inventory:stock:read', 'inventory:stock:adjust',
        'billing:invoices:read', 'billing:invoices:create', 'billing:invoices:approve',
        'billing:quotes:read', 'billing:quotes:create', 'billing:payments:read',
        'purchasing:orders:read', 'purchasing:suppliers:read',
        'crm:customers:read', 'crm:leads:read',
        'finance:accounts:read', 'finance:journal:read', 'finance:reports:read',
        'hr:employees:read', 'hr:payroll:read',
        'reports:dashboard:read', 'reports:sales:read', 'reports:inventory:read',
      ],
    ),
    (
      email: 'ventas@vb-erp.com',
      password: '123456',
      name: 'Carlos Mendoza',
      roles: ['sales_agent'],
      permissions: [
        'billing:invoices:read', 'billing:invoices:create',
        'billing:quotes:read', 'billing:quotes:create',
        'billing:payments:read', 'billing:payments:register',
        'crm:customers:read', 'crm:customers:create',
        'crm:leads:read', 'crm:leads:manage',
        'inventory:products:read', 'inventory:stock:read',
        'reports:dashboard:read', 'reports:sales:read',
      ],
    ),
    (
      email: 'almacen@vb-erp.com',
      password: '123456',
      name: 'Ana Torres',
      roles: ['warehouse_operator'],
      permissions: [
        'inventory:products:read', 'inventory:stock:read',
        'inventory:stock:adjust', 'inventory:stock:transfer',
        'inventory:warehouses:read', 'inventory:categories:read',
        'purchasing:orders:read', 'purchasing:orders:receive',
        'reports:dashboard:read', 'reports:inventory:read',
      ],
    ),
  ];

  AuthTokens? _session;

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 800));

    final match = _users.where(
      (u) => u.email == email.trim().toLowerCase() && u.password == password,
    );

    if (match.isEmpty) {
      throw const AuthMockException('Correo o contraseña incorrectos');
    }

    final u = match.first;
    _session = AuthTokens(
      accessToken:  'mock-access-token',
      refreshToken: 'mock-refresh-token',
      user: AuthUser(
        id:          '00000000-0000-0000-0000-000000000001',
        name:        u.name,
        email:       u.email,
        roles:       List<String>.from(u.roles),
        permissions: List<String>.from(u.permissions),
      ),
    );
    return _session!;
  }

  @override
  Future<void> logout() async => _session = null;

  @override
  Future<AuthTokens?> restoreSession() async => _session;
}

class AuthMockException implements Exception {
  const AuthMockException(this.message);
  final String message;
  @override
  String toString() => message;
}
