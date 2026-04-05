import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../buttons/app_button.dart';

enum ConfirmType { danger, warning, info, success }

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog._({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.type,
    this.onConfirm,
    this.onCancel,
    this.detail,
  });

  final String title;
  final String message;
  final String? detail;
  final String confirmLabel;
  final String cancelLabel;
  final ConfirmType type;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  /// Eliminar un registro
  static Future<bool?> delete({
    required BuildContext context,
    required String itemName,
    String? detail,
  }) =>
      _show(
        context:      context,
        type:         ConfirmType.danger,
        title:        '¿Eliminar $itemName?',
        message:      'Esta acción no se puede deshacer.',
        detail:       detail,
        confirmLabel: 'Sí, eliminar',
      );

  /// Confirmar una acción irreversible genérica
  static Future<bool?> action({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel  = 'Confirmar',
    String? detail,
    ConfirmType type     = ConfirmType.warning,
  }) =>
      _show(
        context:      context,
        type:         type,
        title:        title,
        message:      message,
        detail:       detail,
        confirmLabel: confirmLabel,
      );

  /// Confirmar envío / aprobación
  static Future<bool?> approve({
    required BuildContext context,
    required String itemName,
    String? detail,
  }) =>
      _show(
        context:      context,
        type:         ConfirmType.success,
        title:        '¿Aprobar $itemName?',
        message:      'Una vez aprobado no podrás revertir el estado.',
        detail:       detail,
        confirmLabel: 'Sí, aprobar',
      );

  static Future<bool?> _show({
    required BuildContext context,
    required ConfirmType type,
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'Cancelar',
    String? detail,
  }) =>
      showDialog<bool>(
        context:           context,
        barrierDismissible: false,
        builder: (_) => AppConfirmDialog._(
          title:        title,
          message:      message,
          detail:       detail,
          confirmLabel: confirmLabel,
          cancelLabel:  cancelLabel,
          type:         type,
          onConfirm:    () => Navigator.of(context).pop(true),
          onCancel:     () => Navigator.of(context).pop(false),
        ),
      );

  // ── Helpers de estilo ───────────────────────────────────────────────────────

  (Color bg, Color icon, Color border) get _colors => switch (type) {
        ConfirmType.danger  => (AppColors.errorLight,   AppColors.error,   AppColors.error.withOpacity(0.3)),
        ConfirmType.warning => (AppColors.warningLight, AppColors.warning, AppColors.warning.withOpacity(0.3)),
        ConfirmType.info    => (AppColors.infoLight,    AppColors.info,    AppColors.info.withOpacity(0.3)),
        ConfirmType.success => (AppColors.successLight, AppColors.success, AppColors.success.withOpacity(0.3)),
      };

  IconData get _icon => switch (type) {
        ConfirmType.danger  => Icons.delete_outline,
        ConfirmType.warning => Icons.warning_amber_outlined,
        ConfirmType.info    => Icons.info_outline,
        ConfirmType.success => Icons.check_circle_outline,
      };

  AppButtonVariant get _confirmVariant => switch (type) {
        ConfirmType.danger  => AppButtonVariant.danger,
        ConfirmType.warning => AppButtonVariant.primary,
        ConfirmType.info    => AppButtonVariant.primary,
        ConfirmType.success => AppButtonVariant.primary,
      };

  @override
  Widget build(BuildContext context) {
    final (bgColor, iconColor, borderColor) = _colors;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color:        bgColor,
                  shape:        BoxShape.circle,
                  border:       Border.all(color: borderColor, width: 1.5),
                ),
                child: Icon(_icon, size: 30, color: iconColor),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Título
              Text(
                title,
                style: AppTypography.h3,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Mensaje
              Text(
                message,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              // Detalle adicional (ej: nombre del item a eliminar)
              if (detail != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical:   AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color:        bgColor,
                    borderRadius: AppRadius.cardRadius,
                    border:       Border.all(color: borderColor),
                  ),
                  child: Text(
                    detail!,
                    style: AppTypography.labelMd.copyWith(color: iconColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xl2),

              // Acciones
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label:   cancelLabel,
                      onPressed: onCancel,
                      variant: AppButtonVariant.outline,
                      isFullWidth: true,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label:      confirmLabel,
                      onPressed:  onConfirm,
                      variant:    _confirmVariant,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
