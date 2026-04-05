import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/identity/auth/domain/auth_model.dart';
import 'features/identity/auth/presentation/login/login_page.dart';
import 'features/identity/auth/presentation/splash/splash_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'shared/widgets/layout/app_shell.dart';
import 'shared/widgets/layout/app_sidebar.dart';

void main() => runApp(const VbErpApp());

class VbErpApp extends StatelessWidget {
  const VbErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VB-ERP',
      debugShowCheckedModeBanner: false,
      theme:     AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // dark por defecto
      home: const _AppRouter(),
    );
  }
}

// ── Router de la app ──────────────────────────────────────────────────────────

class _AppRouter extends StatefulWidget {
  const _AppRouter();
  @override
  State<_AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<_AppRouter> {
  _Screen _screen = _Screen.splash;
  AuthTokens? _tokens;
  String _currentRoute = '/dashboard';

  void _goToLogin() =>
      setState(() => _screen = _Screen.login);

  void _goToDashboard(AuthTokens tokens) =>
      setState(() { _tokens = tokens; _screen = _Screen.app; });

  void _logout() =>
      setState(() { _tokens = null; _screen = _Screen.login; });

  @override
  Widget build(BuildContext context) {
    return switch (_screen) {
      _Screen.splash => SplashPage(
          onAuthenticated:   _goToDashboard,
          onUnauthenticated: _goToLogin,
        ),
      _Screen.login => LoginPage(
          onLoginSuccess: (tokens) => _goToDashboard(tokens),
        ),
      _Screen.app => AppShell(
          currentRoute:      _currentRoute,
          sidebarItems:      _buildSidebarItems(_tokens!.user.permissions),
          title:             _routeTitle(_currentRoute),
          userName:          _tokens!.user.name,
          userRole:          _tokens!.user.roles.firstOrNull ?? '',
          userPermissions:   _tokens!.user.permissions,
          notificationCount: 3,
          onNavigate: (route) =>
              setState(() => _currentRoute = route),
          onUserTap: _logout,
          child: _buildPage(_currentRoute),
        ),
    };
  }

  Widget _buildPage(String route) {
    return switch (route) {
      '/dashboard' => DashboardPage(user: _tokens!.user),
      _            => _ComingSoon(route: route),
    };
  }

  String _routeTitle(String route) {
    const map = {
      '/dashboard':          'Dashboard',
      '/identity/users':     'Usuarios',
      '/identity/roles':     'Roles',
      '/inventory/products': 'Productos',
      '/billing/invoices':   'Facturas',
    };
    return map[route] ?? route;
  }
}

enum _Screen { splash, login, app }

// ── Sidebar items del ERP ─────────────────────────────────────────────────────

List<SidebarItem> _buildSidebarItems(List<String> perms) => [
  const SidebarItem(id: 'dashboard', label: 'Dashboard',
      icon: Icons.dashboard_outlined, route: '/dashboard'),
  SidebarItem(id: 'identity', label: 'Usuarios', icon: Icons.people_outline,
    children: [
      const SidebarItem(id: 'users',       label: 'Usuarios',  icon: Icons.person_outline,  route: '/identity/users',       requiredPermission: 'identity:users:read'),
      const SidebarItem(id: 'roles',       label: 'Roles',     icon: Icons.shield_outlined, route: '/identity/roles',       requiredPermission: 'identity:roles:read'),
      const SidebarItem(id: 'permissions', label: 'Permisos',  icon: Icons.lock_outline,    route: '/identity/permissions', requiredPermission: 'identity:permissions:read'),
    ],
  ),
  SidebarItem(id: 'inventory', label: 'Inventario', icon: Icons.inventory_2_outlined,
    children: [
      const SidebarItem(id: 'products',   label: 'Productos',  icon: Icons.category_outlined,  route: '/inventory/products',   requiredPermission: 'inventory:products:read'),
      const SidebarItem(id: 'stock',      label: 'Stock',      icon: Icons.warehouse_outlined,  route: '/inventory/stock',      requiredPermission: 'inventory:stock:read'),
      const SidebarItem(id: 'warehouses', label: 'Almacenes',  icon: Icons.store_outlined,      route: '/inventory/warehouses', requiredPermission: 'inventory:warehouses:read'),
    ],
  ),
  SidebarItem(id: 'billing', label: 'Facturación', icon: Icons.receipt_long_outlined, badge: 3,
    children: [
      const SidebarItem(id: 'invoices', label: 'Facturas',     icon: Icons.description_outlined,   route: '/billing/invoices', requiredPermission: 'billing:invoices:read'),
      const SidebarItem(id: 'quotes',   label: 'Cotizaciones', icon: Icons.request_quote_outlined,  route: '/billing/quotes',   requiredPermission: 'billing:quotes:read'),
      const SidebarItem(id: 'payments', label: 'Pagos',        icon: Icons.payments_outlined,       route: '/billing/payments', requiredPermission: 'billing:payments:read'),
    ],
  ),
  SidebarItem(id: 'purchasing', label: 'Compras', icon: Icons.shopping_cart_outlined,
    children: [
      const SidebarItem(id: 'orders',    label: 'Órdenes',     icon: Icons.list_alt_outlined, route: '/purchasing/orders',    requiredPermission: 'purchasing:orders:read'),
      const SidebarItem(id: 'suppliers', label: 'Proveedores', icon: Icons.business_outlined, route: '/purchasing/suppliers', requiredPermission: 'purchasing:suppliers:read'),
    ],
  ),
  SidebarItem(id: 'crm', label: 'CRM', icon: Icons.handshake_outlined,
    children: [
      const SidebarItem(id: 'customers', label: 'Clientes',   icon: Icons.groups_outlined,   route: '/crm/customers', requiredPermission: 'crm:customers:read'),
      const SidebarItem(id: 'leads',     label: 'Leads',      icon: Icons.trending_up_outlined, route: '/crm/leads',  requiredPermission: 'crm:leads:read'),
    ],
  ),
  SidebarItem(id: 'finance', label: 'Finanzas', icon: Icons.account_balance_outlined,
    children: [
      const SidebarItem(id: 'accounts', label: 'Cuentas',     icon: Icons.account_tree_outlined, route: '/finance/accounts', requiredPermission: 'finance:accounts:read'),
      const SidebarItem(id: 'journal',  label: 'Asientos',    icon: Icons.book_outlined,         route: '/finance/journal',  requiredPermission: 'finance:journal:read'),
    ],
  ),
  SidebarItem(id: 'hr', label: 'RRHH', icon: Icons.badge_outlined,
    children: [
      const SidebarItem(id: 'employees', label: 'Empleados',  icon: Icons.person_pin_outlined,   route: '/hr/employees',  requiredPermission: 'hr:employees:read'),
      const SidebarItem(id: 'payroll',   label: 'Nómina',     icon: Icons.attach_money_outlined,  route: '/hr/payroll',    requiredPermission: 'hr:payroll:read'),
    ],
  ),
  const SidebarItem(id: 'reports', label: 'Reportes',
      icon: Icons.bar_chart_outlined, route: '/reports',
      requiredPermission: 'reports:dashboard:read'),
];

// ── Placeholder para rutas no implementadas ───────────────────────────────────

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.construction, size: 48, color: Color(0xFFD1D5DB)),
          const SizedBox(height: 16),
          Text('En construcción', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(route, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF6B7280),
          )),
        ],
      ),
    );
  }
}
