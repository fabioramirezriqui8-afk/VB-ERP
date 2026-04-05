import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

enum StatTrend { up, down, neutral }

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.trendLabel,
    this.icon,
    this.iconColor,
    this.onTap,
  });

  final String title;
  final String value;
  final String? subtitle;
  final StatTrend? trend;
  final String? trendLabel;   // ej: "+12% vs mes anterior"
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título + ícono
              Row(
                children: [
                  Expanded(
                    child: Text(title,
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.textSecondary,
                        )),
                  ),
                  if (icon != null)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 20,
                          color: iconColor ?? AppColors.primary),
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Valor principal
              Text(value, style: AppTypography.h2),

              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    )),
              ],

              // Tendencia
              if (trend != null && trendLabel != null) ...[
                const SizedBox(height: AppSpacing.md),
                _TrendChip(trend: trend!, label: trendLabel!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendChip extends StatelessWidget {
  const _TrendChip({required this.trend, required this.label});
  final StatTrend trend;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (trend) {
      StatTrend.up      => (AppColors.success, Icons.trending_up),
      StatTrend.down    => (AppColors.error,   Icons.trending_down),
      StatTrend.neutral => (AppColors.textMuted, Icons.trending_flat),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: AppTypography.caption.copyWith(color: color)),
      ],
    );
  }
}
