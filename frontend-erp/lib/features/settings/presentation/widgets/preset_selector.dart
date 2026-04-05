import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_preset.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Solo la selección de presets — sin lógica de persistencia
class PresetSelector extends StatelessWidget {
  const PresetSelector({
    super.key,
    required this.current,
    required this.onSelected,
  });

  final AppThemePreset current;
  final ValueChanged<AppThemePreset> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Presets', style: AppTypography.labelLg),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap:     true,
          physics:        const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing:  AppSpacing.md,
          childAspectRatio: 2.2,
          children: AppThemePresets.all
              .map((p) => _PresetCard(
                    preset:     p,
                    isSelected: p.id == current.id,
                    onTap:      () => onSelected(p),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final AppThemePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color:        preset.neutral,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? preset.primary
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: preset.primary.withOpacity(0.3), blurRadius: 12)]
              : null,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Mini paleta
            Row(
              children: [preset.primary, preset.secondary, preset.tertiary]
                  .map((c) => Container(
                        width: 14, height: 14,
                        margin: const EdgeInsets.only(right: 3),
                        decoration: BoxDecoration(
                          color:  c,
                          shape:  BoxShape.circle,
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                preset.name,
                style: AppTypography.labelMd.copyWith(
                  color: preset.mode == ThemeMode.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, size: 16, color: preset.primary),
          ],
        ),
      ),
    );
  }
}
