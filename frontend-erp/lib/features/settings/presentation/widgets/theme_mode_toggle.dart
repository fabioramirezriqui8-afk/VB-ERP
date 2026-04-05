import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_preset.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Solo el toggle dark/light/system — sin lógica de persistencia
class ThemeModeToggle extends StatelessWidget {
  const ThemeModeToggle({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Modo de pantalla', style: AppTypography.labelLg),
        const SizedBox(height: AppSpacing.md),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              value: ThemeMode.dark,
              icon:  Icon(Icons.dark_mode_outlined),
              label: Text('Oscuro'),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              icon:  Icon(Icons.light_mode_outlined),
              label: Text('Claro'),
            ),
            ButtonSegment(
              value: ThemeMode.system,
              icon:  Icon(Icons.brightness_auto_outlined),
              label: Text('Sistema'),
            ),
          ],
          selected:    {current},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
      ],
    );
  }
}
