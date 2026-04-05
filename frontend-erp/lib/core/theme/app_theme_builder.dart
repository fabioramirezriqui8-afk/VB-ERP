import 'package:flutter/material.dart';
import 'app_theme_preset.dart';
import 'app_radius.dart';
import 'app_typography.dart';

/// Solo construye ThemeData desde un preset — sin estado, sin UI
abstract class AppThemeBuilder {
  static ThemeData build(AppThemePreset preset) {
    final isDark = preset.mode == ThemeMode.dark;
    return isDark ? _buildDark(preset) : _buildLight(preset);
  }

  static ThemeData _buildDark(AppThemePreset p) {
    final surface     = _darken(p.neutral, 0.02);
    final surfaceLow  = p.neutral;
    final onSurface   = _lighten(p.neutral, 0.85);
    final textMuted   = _lighten(p.neutral, 0.45);

    final cs = _colorScheme(
      brightness: Brightness.dark,
      p:          p,
      surface:    surface,
      onSurface:  onSurface,
    );

    return _base(cs, p, surfaceLow, onSurface, textMuted, Brightness.dark);
  }

  static ThemeData _buildLight(AppThemePreset p) {
    final surface    = p.neutral;
    final surfaceLow = _darken(p.neutral, 0.03);
    final onSurface  = _darken(p.neutral, 0.88);
    final textMuted  = _darken(p.neutral, 0.45);

    final cs = _colorScheme(
      brightness: Brightness.light,
      p:          p,
      surface:    surface,
      onSurface:  onSurface,
    );

    return _base(cs, p, surfaceLow, onSurface, textMuted, Brightness.light);
  }

  static ColorScheme _colorScheme({
    required Brightness brightness,
    required AppThemePreset p,
    required Color surface,
    required Color onSurface,
  }) => ColorScheme(
    brightness:          brightness,
    primary:             p.primary,
    onPrimary:           _contrastText(p.primary),
    primaryContainer:    _darken(p.primary, 0.2),
    onPrimaryContainer:  p.tertiary,
    secondary:           p.secondary,
    onSecondary:         _contrastText(p.secondary),
    tertiary:            p.tertiary,
    onTertiary:          _contrastText(p.tertiary),
    error:               const Color(0xFFFFB4AB),
    onError:             const Color(0xFF690005),
    surface:             surface,
    onSurface:           onSurface,
    outline:             p.secondary.withOpacity(0.3),
    outlineVariant:      p.secondary.withOpacity(0.15),
  );

  static ThemeData _base(
    ColorScheme cs,
    AppThemePreset p,
    Color surfaceLow,
    Color onSurface,
    Color textMuted,
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3:            true,
      brightness:              brightness,
      colorScheme:             cs,
      fontFamily:              AppTypography.fontFamily,
      scaffoldBackgroundColor: surfaceLow,

      appBarTheme: AppBarTheme(
        backgroundColor:        cs.surface,
        foregroundColor:        onSurface,
        elevation:              0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTypography.h4.copyWith(color: onSurface),
        iconTheme: IconThemeData(color: p.secondary),
      ),

      cardTheme: CardThemeData(
        color:     cs.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: _contrastText(p.primary),
          elevation:       0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.labelLg,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.primary,
          side: BorderSide(color: p.secondary.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.labelLg,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.secondary,
          textStyle: AppTypography.labelLg,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled:         true,
        fillColor:      isDark
            ? cs.surface.withOpacity(0.6)
            : p.neutral.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: p.secondary.withOpacity(0.3), width: 1.5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: p.secondary.withOpacity(0.2), width: 1.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: p.primary, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFB4AB), width: 1.5),
        ),
        labelStyle: AppTypography.labelMd.copyWith(color: textMuted),
        hintStyle:  AppTypography.bodyMd.copyWith(color: textMuted.withOpacity(0.6)),
        prefixIconColor: textMuted,
        suffixIconColor: textMuted,
      ),

      dividerTheme: DividerThemeData(
        color:     p.secondary.withOpacity(0.12),
        thickness: 1,
        space:     1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: p.tertiary.withOpacity(isDark ? 0.15 : 0.2),
        labelStyle: AppTypography.labelMd.copyWith(color: p.primary),
        side:       BorderSide.none,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: isDark
            ? cs.surface.withOpacity(0.85)
            : cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
          side: BorderSide(color: p.secondary.withOpacity(0.15)),
        ),
        elevation: 0,
        titleTextStyle: AppTypography.h3.copyWith(color: onSurface),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor:           p.primary,
        unselectedLabelColor: textMuted,
        indicatorColor:       p.primary,
        dividerColor:         Colors.transparent,
        labelStyle:           AppTypography.labelMd,
        unselectedLabelStyle: AppTypography.labelMd,
      ),
    );
  }

  // ── Utilidades de color ────────────────────────────────────────────────────

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  static Color _lighten(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  /// Retorna blanco u oscuro según el contraste con el fondo
  static Color _contrastText(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.35 ? const Color(0xFF1A0040) : const Color(0xFFF5F0FF);
  }
}
