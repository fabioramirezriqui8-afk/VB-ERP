import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

enum SnackbarType { success, error, warning, info }

abstract class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final (bg, icon) = switch (type) {
      SnackbarType.success => (AppColors.success, Icons.check_circle_outline),
      SnackbarType.error   => (AppColors.error,   Icons.error_outline),
      SnackbarType.warning => (AppColors.warning,  Icons.warning_amber_outlined),
      SnackbarType.info    => (AppColors.info,     Icons.info_outline),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: bg,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
          content: Row(
            children: [
              Icon(icon, color: AppColors.white, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodyMd.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
