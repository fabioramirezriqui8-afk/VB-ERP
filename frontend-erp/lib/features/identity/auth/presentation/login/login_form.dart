import 'package:flutter/material.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';

/// Solo UI del formulario — recibe callbacks, no sabe de repositorios
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.errorMessage,
  });

  final void Function({required String email, required String password}) onSubmit;
  final bool isLoading;
  final String? errorMessage;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey    = GlobalKey<FormState>();
  final _emailCtrl  = TextEditingController();
  final _passCtrl   = TextEditingController();
  bool  _showPass   = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      email:    _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email
          AppTextField(
            label:         'Correo electrónico',
            hint:          'admin@vb-erp.com',
            controller:    _emailCtrl,
            prefixIcon:    Icons.email_outlined,
            keyboardType:  TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled:       !widget.isLoading,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'El correo es requerido';
              if (!RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-z]{2,}$').hasMatch(v.trim())) {
                return 'Correo inválido';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Contraseña
          AppTextField(
            label:          'Contraseña',
            controller:     _passCtrl,
            prefixIcon:     Icons.lock_outline,
            obscureText:    !_showPass,
            textInputAction: TextInputAction.done,
            enabled:        !widget.isLoading,
            onSubmitted:    (_) => _submit(),
            suffixIcon: IconButton(
              icon: Icon(
                _showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 18,
              ),
              onPressed: () => setState(() => _showPass = !_showPass),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'La contraseña es requerida';
              if (v.length < 6) return 'Mínimo 6 caracteres';
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          // Olvidé mi contraseña
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading ? null : () {},
              child: Text('¿Olvidaste tu contraseña?',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.primary,
                  )),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Error de servidor
          if (widget.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color:        AppColors.errorSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.20),
                ),
                boxShadow: [
                  BoxShadow(
                    color:      AppColors.errorGlow,
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: AppColors.error),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(widget.errorMessage!,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.error,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Botón
          AppButton(
            label:       'Iniciar sesión',
            onPressed:   widget.isLoading ? null : _submit,
            isLoading:   widget.isLoading,
            isFullWidth: true,
            size:        AppButtonSize.lg,
          ),
        ],
      ),
    );
  }
}
