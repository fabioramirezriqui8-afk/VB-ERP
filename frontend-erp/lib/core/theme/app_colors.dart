import 'package:flutter/material.dart';

/// Paleta fija del design system
abstract class AppColors {

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary    = Color(0xFF0F172A); // azul marino oscuro
  static const Color secondary  = Color(0xFF475569); // gris azulado
  static const Color accent     = Color(0xFF2563EB); // azul brillante (botones, acciones)
  static const Color accentLight = Color(0xFFEFF6FF); // fondo suave del accent

  // ── Superficies ────────────────────────────────────────────────────────────
  static const Color background      = Color(0xFFF1F5F9); // fondo general de vistas
  static const Color surface         = Color(0xFFFFFFFF); // cards, modales
  static const Color surfaceVariant  = Color(0xFFEEF2FF); // fondo alternativo suave
  static const Color surfaceHover    = Color(0xFFF8FAFC); // hover en filas

  // ── Texto ──────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF0F172A); // títulos
  static const Color textSecondary = Color(0xFF475569); // subtítulos, labels
  static const Color textMuted     = Color(0xFF94A3B8); // placeholders, deshabilitados
  static const Color textDisabled  = Color(0xFFCBD5E1);

  // ── Bordes ─────────────────────────────────────────────────────────────────
  static const Color border       = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);

  // ── Semánticos ─────────────────────────────────────────────────────────────
  static const Color success        = Color(0xFF16A34A);
  static const Color successSurface = Color(0xFFF0FDF4);
  static const Color successText    = Color(0xFF15803D);

  static const Color warning        = Color(0xFFD97706);
  static const Color warningSurface = Color(0xFFFFFBEB);
  static const Color warningText    = Color(0xFFB45309);

  static const Color error          = Color(0xFFDC2626);
  static const Color errorSurface   = Color(0xFFFEF2F2);
  static const Color errorText      = Color(0xFFB91C1C);

  static const Color info           = Color(0xFF0284C7);
  static const Color infoSurface    = Color(0xFFF0F9FF);
  static const Color infoText       = Color(0xFF0369A1);

  // ── Sidebar ────────────────────────────────────────────────────────────────
  static const Color sidebarBg     = Color(0xFF0F172A);
  static const Color sidebarActive = Color(0xFF1E293B);
  static const Color sidebarText   = Color(0xFF94A3B8);

  // ── Tabla ──────────────────────────────────────────────────────────────────
  static const Color tableHeader     = Color(0xFF3B82F6); // azul medio-oscuro
  static const Color tableHeaderText = Color(0xFFFFFFFF); // blanco
  static const Color tableRowOdd     = Color(0xFFFFFFFF);
  static const Color tableRowEven    = Color(0xFFF8FAFC);
  static const Color tableRowHover   = Color(0xFFEFF6FF);

  // ── Utilidades ─────────────────────────────────────────────────────────────
  static const Color white       = Color(0xFFFFFFFF);
  static const Color black       = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // ── Aliases de compatibilidad ──────────────────────────────────────────────
  static const Color onPrimary           = white;
  static const Color primaryContainer    = Color(0xFF1E293B);
  static const Color primaryFixedVariant = Color(0xFF334155);
  static const Color onPrimaryContainer  = Color(0xFFE2E8F0);
  static const Color onSecondary         = white;
  static const Color secondaryContainer  = Color(0xFF334155);
  static const Color onSurface          = textPrimary;
  static const Color outlineVariant      = border;
  static const Color borderStrong_       = borderStrong;
  static const Color surfaceLowest       = Color(0xFF0F172A);
  static const Color surfaceLow         = Color(0xFF1E293B);
  static const Color surfaceHigh        = surface;
  static const Color surfaceHighest     = surfaceVariant;
  static const Color surfaceBright      = Color(0xFFF1F5F9);
  static const Color surfaceElevated    = surface;
  static const Color primaryLight       = accentLight;
  static const Color primaryDark        = primary;
  static const Color primaryGlow        = Color(0x332563EB);
  static const Color errorLight         = errorSurface;
  static const Color successLight       = successSurface;
  static const Color warningLight       = warningSurface;
  static const Color infoLight          = infoSurface;
  static const Color errorGlow          = Color(0x33DC2626);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin:  Alignment.topLeft,
    end:    Alignment.bottomRight,
  );

  static List<BoxShadow> get floatingShadow => [
    const BoxShadow(color: Color(0x1A0F172A), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static Color get ghostBorder => border.withOpacity(0.5);
  static Color get softBorder  => border;
}
