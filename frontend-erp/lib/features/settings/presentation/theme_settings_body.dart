import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_theme_preset.dart';
import 'theme_controller.dart';
import 'widgets/color_token_picker.dart';
import 'widgets/preset_selector.dart';
import 'widgets/theme_mode_toggle.dart';
import 'widgets/theme_preview.dart';

/// Solo el layout del panel — sin lógica de estado
class ThemeSettingsBody extends StatelessWidget {
  const ThemeSettingsBody({super.key, required this.controller});
  final ThemeController controller;

  // Swatches sugeridos por token
  static const _primarySwatches = [
    Color(0xFF4A148C), Color(0xFF1565C0), Color(0xFF00695C),
    Color(0xFFBF360C), Color(0xFF263238), Color(0xFF6366F1),
  ];
  static const _secondarySwatches = [
    Color(0xFFB0BEC5), Color(0xFF90A4AE), Color(0xFF78909C),
    Color(0xFF94A3B8), Color(0xFF9CA3AF), Color(0xFF6B7280),
  ];
  static const _tertiarySwatches = [
    Color(0xFFE1BEE7), Color(0xFFCE93D8), Color(0xFFA5B4FC),
    Color(0xFF7DD3FC), Color(0xFF86EFAC), Color(0xFFFCD34D),
  ];
  static const _neutralSwatches = [
    Color(0xFF121212), Color(0xFF0E0E0E), Color(0xFF1C1B1B),
    Color(0xFF0A1628), Color(0xFFFFFFFF), Color(0xFFF8FAFC),
  ];

  @override
  Widget build(BuildContext context) {
    final preset = controller.preset;

    return ListenableBuilder(
      listenable: controller,
      builder: (_, __) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl2),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Preview en vivo ─────────────────────────────────────────
              ThemePreview(preset: controller.preset),
              const SizedBox(height: AppSpacing.xl3),

              // ── Modo ────────────────────────────────────────────────────
              ThemeModeToggle(
                current:   controller.mode,
                onChanged: controller.setMode,
              ),
              const SizedBox(height: AppSpacing.xl3),

              // ── Presets ─────────────────────────────────────────────────
              PresetSelector(
                current:    controller.preset,
                onSelected: controller.applyPreset,
              ),
              const SizedBox(height: AppSpacing.xl3),

              // ── Tokens de color ─────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 4, height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text('Personalización de Tokens', style: AppTypography.h4),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.lg + 4),
                child: Text(
                  'Ajusta la profundidad cromática de la interfaz en tiempo real.',
                  style: AppTypography.bodyMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl2),

              _TokenSection(
                children: [
                  _TokenItem(
                    icon: Icons.colorize_rounded,
                    child: ColorTokenPicker(
                      label:       'Primary',
                      description: 'Identidad, acciones principales y estados activos',
                      color:       preset.primary,
                      swatches:    _primarySwatches,
                      onChanged:   controller.setPrimary,
                    ),
                  ),
                  const Divider(height: AppSpacing.xl3, indent: 48),
                  _TokenItem(
                    icon: Icons.opacity_rounded,
                    child: ColorTokenPicker(
                      label:       'Secondary',
                      description: 'Iconografía, bordes y elementos de apoyo',
                      color:       preset.secondary,
                      swatches:    _secondarySwatches,
                      onChanged:   controller.setSecondary,
                    ),
                  ),
                  const Divider(height: AppSpacing.xl3, indent: 48),
                  _TokenItem(
                    icon: Icons.auto_awesome_rounded,
                    child: ColorTokenPicker(
                      label:       'Tertiary',
                      description: 'Acentos, hovers y micro-interacciones',
                      color:       preset.tertiary,
                      swatches:    _tertiarySwatches,
                      onChanged:   controller.setTertiary,
                    ),
                  ),
                  const Divider(height: AppSpacing.xl3, indent: 48),
                  _TokenItem(
                    icon: Icons.layers_rounded,
                    child: ColorTokenPicker(
                      label:       'Neutral',
                      description: 'Superficie base y profundidad del canvas',
                      color:       preset.neutral,
                      swatches:    _neutralSwatches,
                      onChanged:   controller.setNeutral,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl3),

              // ── Reset ───────────────────────────────────────────────────
              OutlinedButton.icon(
                onPressed: () => controller.applyPreset(AppThemePresets.sovereignDark),
                icon:  const Icon(Icons.refresh, size: 16),
                label: const Text('Restaurar valores por defecto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TokenSection extends StatelessWidget {
  const _TokenSection({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color:        cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _TokenItem extends StatelessWidget {
  const _TokenItem({required this.icon, required this.child});
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: cs.primary.withOpacity(0.7)),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(child: child),
      ],
    );
  }
}
