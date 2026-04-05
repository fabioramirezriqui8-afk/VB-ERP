import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_preset.dart';
import '../../../../core/theme/app_theme_builder.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Solo el preview en vivo — recibe el preset y renderiza una mini UI
class ThemePreview extends StatelessWidget {
  const ThemePreview({super.key, required this.preset});
  final AppThemePreset preset;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeBuilder.build(preset);
    final isDark = preset.mode == ThemeMode.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor  = isDark ? Colors.white60 : Colors.black54;

    return Theme(
      data: theme,
      child: Container(
        decoration: BoxDecoration(
          color:        preset.neutral,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.1)),
          boxShadow: [
            BoxShadow(
              color: preset.primary.withOpacity(0.08),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.remove_red_eye_rounded, size: 14, color: preset.primary),
                const SizedBox(width: 8),
                Text('Visualización del Sistema',
                    style: AppTypography.labelSm.copyWith(
                      color: preset.primary.withOpacity(0.8),
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Mini Navbar
            Container(
              height: 40,
              decoration: BoxDecoration(
                color:        isDark
                    ? Colors.white.withOpacity(0.03)
                    : Colors.black.withOpacity(0.02),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.02)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.grid_view_rounded, size: 14, color: preset.primary),
                  const SizedBox(width: 8),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: subColor.withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
                  const Spacer(),
                  CircleAvatar(radius: 10, backgroundColor: preset.primary.withOpacity(0.2), child: Icon(Icons.person, size: 10, color: preset.primary)),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Mini Layout (Sidebar + Content)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mini Side
                Container(
                  width: 32,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: List.generate(4, (i) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Icon(
                        [Icons.dashboard, Icons.people, Icons.inventory, Icons.settings][i],
                        size: 10,
                        color: i == 0 ? preset.primary : subColor.withOpacity(0.3),
                      ),
                    )),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Mini Content
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _MiniStat(label: 'Neto', value: '\$12K', color: preset.primary, isDark: isDark),
                          const SizedBox(width: AppSpacing.sm),
                          _MiniStat(label: 'Crec.', value: '+14%', color: preset.tertiary, isDark: isDark),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        height: 38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(Icons.bar_chart_rounded, size: 20, color: preset.secondary.withOpacity(0.3)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.color, required this.isDark});
  final String label, value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 7, color: isDark ? Colors.white38 : Colors.black38, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
    required this.isDark,
  });
  final String label, value;
  final Color color, bg;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(6),
          border: Border(left: BorderSide(color: color, width: 2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.white38 : Colors.black38,
                )),
            Text(value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                )),
          ],
        ),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    required this.label,
    required this.bg,
    this.border,
    this.textColor,
  });
  final String label;
  final Color bg;
  final Color? border;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color:        bg,
        borderRadius: BorderRadius.circular(5),
        border: border != null ? Border.all(color: border!) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}
