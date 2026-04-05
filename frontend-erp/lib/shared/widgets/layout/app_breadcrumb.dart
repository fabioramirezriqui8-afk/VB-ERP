import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class BreadcrumbItem {
  const BreadcrumbItem({required this.label, this.route});
  final String label;
  final String? route; // null = ítem actual (no clickeable)
}

class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({super.key, required this.items, this.onNavigate});

  final List<BreadcrumbItem> items;
  final void Function(String route)? onNavigate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.asMap().entries.expand((e) {
          final isLast = e.key == items.length - 1;
          final item   = e.value;
          return [
            if (e.key > 0)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
              ),
            isLast || item.route == null
                ? Text(item.label,
                    style: AppTypography.labelMd.copyWith(
                      color: isLast ? AppColors.onSurface : AppColors.textSecondary,
                    ))
                : InkWell(
                    onTap: () => onNavigate?.call(item.route!),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                      child: Text(item.label,
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          )),
                    ),
                  ),
          ];
        }).toList(),
      ),
    );
  }
}
