import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AppTabItem {
  const AppTabItem({required this.label, this.icon, this.badge});
  final String label;
  final IconData? icon;
  final int? badge;
}

/// Tab bar estilizado para secciones dentro de una pantalla.
/// Uso: Factura > [Detalle] [Pagos] [Historial]
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.controller,
  });

  final List<AppTabItem> tabs;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller:       controller,
      isScrollable:     tabs.length > 4,
      labelStyle:       AppTypography.labelMd,
      unselectedLabelStyle: AppTypography.labelMd,
      labelColor:       AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor:   AppColors.primary,
      indicatorWeight:  2,
      dividerColor:     AppColors.border,
      tabs: tabs.map((t) => Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (t.icon != null) ...[
              Icon(t.icon, size: 16),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(t.label),
            if (t.badge != null && t.badge! > 0) ...[
              const SizedBox(width: AppSpacing.xs),
              _TabBadge(count: t.badge!),
            ],
          ],
        ),
      )).toList(),
    );
  }
}

class _TabBadge extends StatelessWidget {
  const _TabBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: AppTypography.labelSm.copyWith(color: AppColors.primary),
      ),
    );
  }
}
