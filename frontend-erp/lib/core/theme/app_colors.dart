import 'package:flutter/material.dart';

/// Paleta "The Sovereign Command" — Chromatic Depth
/// Basada en obsidian profundo + violetas reales
abstract class AppColors {

  // ── Superficies (capas físicas apiladas) ───────────────────────────────────
  static const Color surfaceLowest   = Color(0xFF0E0E0E); // base más profunda
  static const Color surfaceLow      = Color(0xFF1C1B1B); // áreas de trabajo
  static const Color surface         = Color(0xFF232323); // superficie base
  static const Color surfaceHigh     = Color(0xFF2A2A2A); // módulos activos
  static const Color surfaceHighest  = Color(0xFF353534); // cards anidadas
  static const Color surfaceBright   = Color(0xFF3D3C3C); // hover states

  // ── Brand — Violeta Real ───────────────────────────────────────────────────
  static const Color primary             = Color(0xFFD7BAFF); // highlight principal
  static const Color primaryContainer    = Color(0xFF4A148C); // gradiente inicio
  static const Color primaryFixedVariant = Color(0xFF5A2A9C); // gradiente fin
  static const Color onPrimary           = Color(0xFF1A0040); // texto sobre primary
  static const Color onPrimaryContainer  = Color(0xFFEADDFF); // texto sobre container

  static const Color secondary           = Color(0xFFB0BEC5); // texto secundario
  static const Color secondaryContainer  = Color(0xFF2D3748);
  static const Color onSecondary         = Color(0xFF1A2332);

  // ── Semánticos (sofisticados, no agresivos) ────────────────────────────────
  static const Color success        = Color(0xFF4CAF82);
  static const Color successSurface = Color(0xFF0D2B1E);
  static const Color successText    = Color(0xFF86EFAC);

  static const Color warning        = Color(0xFFE8A838);
  static const Color warningSurface = Color(0xFF2B1E08);
  static const Color warningText    = Color(0xFFFCD34D);

  static const Color error          = Color(0xFFFFB4AB); // sofisticado, no rojo agresivo
  static const Color errorSurface   = Color(0xFF2B0A08);
  static const Color errorGlow      = Color(0x33FFB4AB);

  static const Color info           = Color(0xFF67C8E8);
  static const Color infoSurface    = Color(0xFF0A1F2B);

  // ── Texto ──────────────────────────────────────────────────────────────────
  static const Color onSurface      = Color(0xFFE5E2E1); // máximo brillo (no blanco puro)
  static const Color textSecondary  = Color(0xFFB0BEC5); // info no esencial
  static const Color textMuted      = Color(0xFF6B7280);
  static const Color textDisabled   = Color(0xFF4B5563);

  // ── Bordes (regla "Ghost Border") ──────────────────────────────────────────
  // Nunca usar bordes sólidos de 1px — solo como fallback de accesibilidad
  static const Color outlineVariant = Color(0xFF3F3F46); // base para 15% opacity
  static Color get ghostBorder => outlineVariant.withOpacity(0.15);
  static Color get softBorder   => outlineVariant.withOpacity(0.25);

  // ── Glassmorphism ──────────────────────────────────────────────────────────
  static Color get glassSurface => surface.withOpacity(0.60);
  static Color get glassModal   => surfaceHigh.withOpacity(0.70);

  // ── Gradientes ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryContainer, primaryFixedVariant],
    begin:  Alignment.topLeft,
    end:    Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0E0E0E), Color(0xFF1A1040), Color(0xFF0E0E0E)],
    begin:  Alignment.topLeft,
    end:    Alignment.bottomRight,
  );

  // ── Sombras con tinte violeta ──────────────────────────────────────────────
  static List<BoxShadow> get floatingShadow => [
    const BoxShadow(
      color:       Color(0x66000000),
      blurRadius:  48,
      offset:      Offset(0, 24),
    ),
    const BoxShadow(
      color:       Color(0x1A4A148C), // tinte violeta del primary
      blurRadius:  12,
    ),
  ];

  // ── Sidebar ────────────────────────────────────────────────────────────────
  static const Color sidebarBg     = surfaceLowest;
  static const Color sidebarActive = Color(0xFF1E1040); // violeta oscuro sutil

  // ── Utilidades ─────────────────────────────────────────────────────────────
  static const Color white       = Color(0xFFFFFFFF);
  static const Color black       = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // ── Aliases de compatibilidad ──────────────────────────────────────────────
  static const Color background        = surfaceLowest;
  static const Color border            = outlineVariant;
  static const Color borderStrong      = surfaceBright;
  static const Color surfaceElevated   = surfaceHigh;
  static const Color surfaceHover      = surfaceBright;
  static const Color surfaceVariantLight = Color(0xFFF4F4F5);
  static const Color textPrimary       = onSurface;
  static const Color primaryLight      = Color(0xFFEADDFF);
  static const Color primaryDark       = primaryContainer;
  static const Color primaryGlow       = Color(0x336366F1);
  static const Color successLight      = successSurface;
  static const Color warningLight      = warningSurface;
  static const Color errorLight        = errorSurface;
  static const Color infoLight         = infoSurface;
}
