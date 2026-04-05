import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../buttons/app_button.dart';

/// Modal base del ERP.
/// Para formularios simples usa [AppModal.show].
/// Para formularios complejos usa [AppSideSheet.show] (panel lateral).
class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.confirmLabel  = 'Guardar',
    this.cancelLabel   = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.isLoading     = false,
    this.width         = 520,
    this.showActions   = true,
    this.confirmVariant = AppButtonVariant.primary,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;
  final double width;
  final bool showActions;
  final AppButtonVariant confirmVariant;

  /// Abre el modal centrado (ideal para formularios medianos)
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    String? subtitle,
    String confirmLabel  = 'Guardar',
    String cancelLabel   = 'Cancelar',
    VoidCallback? onConfirm,
    bool isLoading       = false,
    double width         = 520,
    bool showActions     = true,
    AppButtonVariant confirmVariant = AppButtonVariant.primary,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: !isLoading,
      builder: (_) => AppModal(
        title:          title,
        subtitle:       subtitle,
        child:          child,
        confirmLabel:   confirmLabel,
        cancelLabel:    cancelLabel,
        onConfirm:      onConfirm,
        onCancel:       () => Navigator.of(context).pop(),
        isLoading:      isLoading,
        width:          width,
        showActions:    showActions,
        confirmVariant: confirmVariant,
      ),
    );
  }

  /// Modal de confirmación de eliminación
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Eliminar',
    String cancelLabel  = 'Cancelar',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AppModal(
        title:          title,
        confirmLabel:   confirmLabel,
        cancelLabel:    cancelLabel,
        confirmVariant: AppButtonVariant.danger,
        onConfirm:      () => Navigator.of(context).pop(true),
        onCancel:       () => Navigator.of(context).pop(false),
        child: Text(message, style: AppTypography.bodyMd),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width, maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ModalHeader(title: title, subtitle: subtitle, onClose: onCancel),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl2),
                child: child,
              ),
            ),
            if (showActions) ...[
              const Divider(height: 1),
              _ModalFooter(
                confirmLabel:   confirmLabel,
                cancelLabel:    cancelLabel,
                onConfirm:      onConfirm,
                onCancel:       onCancel,
                isLoading:      isLoading,
                confirmVariant: confirmVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Side Sheet (panel lateral) ────────────────────────────────────────────────
/// Ideal para formularios complejos o con muchos campos
class AppSideSheet extends StatelessWidget {
  const AppSideSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.confirmLabel  = 'Guardar',
    this.cancelLabel   = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.isLoading     = false,
    this.width         = 480,
    this.showActions   = true,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;
  final double width;
  final bool showActions;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    String? subtitle,
    String confirmLabel = 'Guardar',
    VoidCallback? onConfirm,
    bool isLoading      = false,
    double width        = 480,
    bool showActions    = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: !isLoading,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
      pageBuilder: (ctx, _, __) => Align(
        alignment: Alignment.centerRight,
        child: AppSideSheet(
          title:        title,
          subtitle:     subtitle,
          child:        child,
          confirmLabel: confirmLabel,
          onConfirm:    onConfirm,
          onCancel:     () => Navigator.of(ctx).pop(),
          isLoading:    isLoading,
          width:        width,
          showActions:  showActions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 16,
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ModalHeader(title: title, subtitle: subtitle, onClose: onCancel),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl2),
                child: child,
              ),
            ),
            if (showActions) ...[
              const Divider(height: 1),
              _ModalFooter(
                confirmLabel: confirmLabel,
                cancelLabel:  cancelLabel,
                onConfirm:    onConfirm,
                onCancel:     onCancel,
                isLoading:    isLoading,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Partes internas ───────────────────────────────────────────────────────────

class _ModalHeader extends StatelessWidget {
  const _ModalHeader({required this.title, this.subtitle, this.onClose});
  final String title;
  final String? subtitle;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl2, AppSpacing.lg, AppSpacing.sm, AppSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.h3),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTypography.bodySm),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }
}

class _ModalFooter extends StatelessWidget {
  const _ModalFooter({
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isLoading,
    this.onConfirm,
    this.onCancel,
    this.confirmVariant = AppButtonVariant.primary,
  });

  final String confirmLabel;
  final String cancelLabel;
  final bool isLoading;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final AppButtonVariant confirmVariant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton(
            label:   cancelLabel,
            onPressed: onCancel,
            variant: AppButtonVariant.ghost,
          ),
          const SizedBox(width: AppSpacing.sm),
          AppButton(
            label:     confirmLabel,
            onPressed: onConfirm,
            variant:   confirmVariant,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
