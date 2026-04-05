import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../feedback/app_loading_indicator.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }
enum AppButtonSize    { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant  = AppButtonVariant.primary,
    this.size     = AppButtonSize.md,
    this.icon,
    this.isLoading = false,
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
    final child = isLoading
        ? const AppLoadingIndicator(size: 18, color: Colors.white)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _iconSize),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label),
            ],
          );

    final btn = switch (variant) {
      AppButtonVariant.primary   => ElevatedButton(onPressed: isLoading ? null : onPressed, style: _primaryStyle(context), child: child),
      AppButtonVariant.secondary => ElevatedButton(onPressed: isLoading ? null : onPressed, style: _secondaryStyle(context), child: child),
      AppButtonVariant.outline   => OutlinedButton(onPressed: isLoading ? null : onPressed, style: _outlineStyle(context), child: child),
      AppButtonVariant.ghost     => TextButton(onPressed: isLoading ? null : onPressed, style: _ghostStyle(context), child: child),
      AppButtonVariant.danger    => ElevatedButton(onPressed: isLoading ? null : onPressed, style: _dangerStyle(context), child: child),
    };

    return isFullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }

  double get _iconSize => switch (size) {
    AppButtonSize.sm => 14,
    AppButtonSize.md => 16,
    AppButtonSize.lg => 18,
  };

  EdgeInsets get _padding => switch (size) {
    AppButtonSize.sm => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    AppButtonSize.md => const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    AppButtonSize.lg => const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
  };

  double get _fontSize => switch (size) {
    AppButtonSize.sm => 12,
    AppButtonSize.md => 14,
    AppButtonSize.lg => 16,
  };

  ButtonStyle _base() => ButtonStyle(
    padding: WidgetStatePropertyAll(_padding),
    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w500)),
  );

  ButtonStyle _primaryStyle(BuildContext ctx) => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    elevation: 0,
  ).merge(_base());

  ButtonStyle _secondaryStyle(BuildContext ctx) => ElevatedButton.styleFrom(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.white,
    elevation: 0,
  ).merge(_base());

  ButtonStyle _outlineStyle(BuildContext ctx) => OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    side: const BorderSide(color: AppColors.primary),
  ).merge(_base());

  ButtonStyle _ghostStyle(BuildContext ctx) => TextButton.styleFrom(
    foregroundColor: AppColors.primary,
  ).merge(_base());

  ButtonStyle _dangerStyle(BuildContext ctx) => ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: AppColors.white,
    elevation: 0,
  ).merge(_base());
}
