import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../feedback/app_loading_indicator.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }
enum AppButtonSize    { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant     = AppButtonVariant.primary,
    this.size        = AppButtonSize.md,
    this.icon,
    this.isLoading   = false,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final content = isLoading
        ? AppLoadingIndicator(size: _iconSize, color: _fgColor)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _iconSize, color: _fgColor),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: TextStyle(fontSize: _fontSize,
                  fontWeight: FontWeight.w500, color: _fgColor)),
            ],
          );

    Widget btn = _buildButton(context, content);
    return isFullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }

  Widget _buildButton(BuildContext context, Widget content) {
    final padding = EdgeInsets.symmetric(
      horizontal: _hPad, vertical: _vPad,
    );

    switch (variant) {
      case AppButtonVariant.primary:
        return _GradientButton(
          onPressed: isLoading ? null : onPressed,
          padding:   padding,
          child:     content,
        );

      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.outlineVariant.withOpacity(0.20)),
            padding: padding,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          ),
          child: content,
        );

      case AppButtonVariant.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondary,
            padding: padding,
          ),
          child: content,
        );

      case AppButtonVariant.danger:
        return _GradientButton(
          onPressed: isLoading ? null : onPressed,
          padding:   padding,
          colors:    [AppColors.errorSurface, const Color(0xFF7F1D1D)],
          child:     content,
        );
    }
  }

  Color get _fgColor => switch (variant) {
    AppButtonVariant.primary   => AppColors.onPrimary,
    AppButtonVariant.secondary => AppColors.primary,
    AppButtonVariant.ghost     => AppColors.secondary,
    AppButtonVariant.danger    => AppColors.error,
  };

  double get _iconSize => switch (size) {
    AppButtonSize.sm => 14, AppButtonSize.md => 16, AppButtonSize.lg => 18,
  };
  double get _fontSize => switch (size) {
    AppButtonSize.sm => 12, AppButtonSize.md => 14, AppButtonSize.lg => 16,
  };
  double get _hPad => switch (size) {
    AppButtonSize.sm => 12, AppButtonSize.md => 20, AppButtonSize.lg => 28,
  };
  double get _vPad => switch (size) {
    AppButtonSize.sm => 8, AppButtonSize.md => 12, AppButtonSize.lg => 16,
  };
}

/// Botón con gradiente violeta — el CTA principal del design system
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.onPressed,
    required this.child,
    required this.padding,
    this.colors,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    final gradient = colors != null
        ? LinearGradient(colors: colors!)
        : AppColors.primaryGradient;

    return Material(
      color:        Colors.transparent,
      borderRadius: AppRadius.button,
      child: InkWell(
        onTap:        onPressed,
        borderRadius: AppRadius.button,
        splashColor:  AppColors.primaryFixedVariant.withOpacity(0.3),
        child: Ink(
          decoration: BoxDecoration(
            gradient:     onPressed != null ? gradient : null,
            color:        onPressed == null ? AppColors.surfaceHigh : null,
            borderRadius: AppRadius.button,
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
