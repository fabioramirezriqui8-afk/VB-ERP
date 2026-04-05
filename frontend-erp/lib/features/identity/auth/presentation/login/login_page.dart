import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/config/env.dart';
import '../../domain/auth_model.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_storage.dart';
import 'login_controller.dart';
import 'login_form.dart';

/// Solo scaffold + navegación — no tiene lógica de negocio
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLoginSuccess});

  final void Function(AuthTokens tokens) onLoginSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(
      repository: AuthRepository(
        baseUrl: Env.apiBaseUrl,
        storage: AuthStorage(),
      ),
    )..addListener(_onStateChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChange);
    _controller.dispose();
    super.dispose();
  }

  void _onStateChange() {
    if (_controller.status == LoginStatus.success && _controller.tokens != null) {
      widget.onLoginSuccess(_controller.tokens!);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size   = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: isWide
          ? _WideLayout(controller: _controller)
          : _NarrowLayout(controller: _controller),
    );
  }
}

// ── Layout ancho (web/desktop) ────────────────────────────────────────────────

class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.controller});
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Panel izquierdo — branding
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end:   Alignment.bottomRight,
                colors: [
                  Color(0xFF0F0F1A),
                  Color(0xFF1A1040),
                  Color(0xFF0F0F1A),
                ],
              ),
            ),
            child: const _BrandPanel(),
          ),
        ),
        // Panel derecho — formulario
        SizedBox(
          width: 480,
          child: Container(
            color: AppColors.surfaceLow,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl4),
                child: _LoginCard(controller: controller),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Layout estrecho (móvil) ───────────────────────────────────────────────────

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({required this.controller});
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl2),
        child: Column(
          children: [
            const _LogoMobile(),
            const SizedBox(height: AppSpacing.xl3),
            _LoginCard(controller: controller),
          ],
        ),
      ),
    );
  }
}

// ── Card del formulario ───────────────────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.controller});
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Bienvenido', style: AppTypography.h1),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Ingresa tus credenciales para continuar',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl3),
          LoginForm(
            isLoading:    controller.isLoading,
            errorMessage: controller.error,
            onSubmit: ({required email, required password}) =>
                controller.login(email: email, password: password),
          ),
          const SizedBox(height: AppSpacing.xl2),
          Center(
            child: Text(
              'VB-ERP v1.0 — © 2026',
              style: AppTypography.caption,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Panel de branding ─────────────────────────────────────────────────────────

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.hub_outlined, size: 56, color: Colors.white),
          const SizedBox(height: AppSpacing.xl2),
          Text('VB-ERP',
              style: AppTypography.displayMd.copyWith(color: Colors.white)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Sistema de gestión empresarial\nintegrado para tu negocio.',
            style: AppTypography.bodyLg.copyWith(
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xl4),
          ...[
            'Inventario y almacenes',
            'Facturación y cobranza',
            'Compras y proveedores',
            'Finanzas y contabilidad',
            'Recursos humanos',
          ].map((f) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 18, color: Colors.white70),
                    const SizedBox(width: AppSpacing.sm),
                    Text(f,
                        style: AppTypography.bodyMd.copyWith(
                          color: Colors.white70,
                        )),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _LogoMobile extends StatelessWidget {
  const _LogoMobile();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color:        AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.hub_outlined, size: 40, color: Colors.white),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('VB-ERP', style: AppTypography.h2),
      ],
    );
  }
}
