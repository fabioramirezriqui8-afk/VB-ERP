import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_storage.dart';
import '../../domain/auth_model.dart';

/// Verifica si hay sesión guardada antes de mostrar login o dashboard
class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.onAuthenticated,
    required this.onUnauthenticated,
  });

  final void Function(AuthTokens tokens) onAuthenticated;
  final VoidCallback onUnauthenticated;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 800)); // animación mínima
    final repo   = AuthRepository(
      baseUrl: 'http://localhost:3000',
      storage: AuthStorage(),
    );
    final tokens = await repo.restoreSession();
    if (!mounted) return;
    tokens != null
        ? widget.onAuthenticated(tokens)
        : widget.onUnauthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end:   Alignment.bottomRight,
            colors: [Color(0xFF09090B), Color(0xFF1A1040), Color(0xFF09090B)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glow effect
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGlow,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.hub_outlined, size: 40,
                    color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              Text('VB-ERP',
                  style: AppTypography.displayMd.copyWith(
                    color: AppColors.textPrimary,
                  )),
              const SizedBox(height: 8),
              Text('Sistema de gestión empresarial',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.textMuted,
                  )),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
