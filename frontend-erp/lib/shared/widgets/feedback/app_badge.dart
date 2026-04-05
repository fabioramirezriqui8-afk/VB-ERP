import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

enum AppBadgeVariant { success, warning, error, info, neutral, primary }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
  });

  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical:   AppSpacing.xs,
      ),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.chipRadius),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppTypography.labelSm.copyWith(color: fg)),
        ],
      ),
    );
  }

  (Color bg, Color fg) get _colors => switch (variant) {
    AppBadgeVariant.success => (AppColors.successLight, AppColors.success),
    AppBadgeVariant.warning => (AppColors.warningLight, AppColors.warning),
    AppBadgeVariant.error   => (AppColors.errorLight,   AppColors.error),
    AppBadgeVariant.info    => (AppColors.infoLight,    AppColors.info),
    AppBadgeVariant.primary => (AppColors.primaryLight, AppColors.primaryDark),
    AppBadgeVariant.neutral => (AppColors.surfaceElevated, AppColors.textSecondary),
  };
}
