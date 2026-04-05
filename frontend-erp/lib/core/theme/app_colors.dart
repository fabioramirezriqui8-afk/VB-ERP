import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Brand — Índigo/Violeta ─────────────────────────────────────────────────
  static const Color primary        = Color(0xFF6366F1); // índigo vibrante
  static const Color primaryLight   = Color(0xFF818CF8);
  static const Color primaryDark    = Color(0xFF4F46E5);
  static const Color primaryGlow    = Color(0x336366F1); // para sombras/glow

  static const Color secondary      = Color(0xFF8B5CF6); // violeta
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color secondaryDark  = Color(0xFF7C3AED);

  static const Color accent         = Color(0xFF06B6D4); // cyan para highlights

  // ── Semánticos ─────────────────────────────────────────────────────────────
  static const Color success        = Color(0xFF10B981);
  static const Color successLight   = Color(0xFF064E3B);
  static const Color successText    = Color(0xFF6EE7B7);

  static const Color warning        = Color(0xFFF59E0B);
  static const Color warningLight   = Color(0xFF451A03);
  static const Color warningText    = Color(0xFFFCD34D);

  static const Color error          = Color(0xFFEF4444);
  static const Color errorLight     = Color(0xFF450A0A);
  static const Color errorText      = Color(0xFFFCA5A5);

  static const Color info           = Color(0xFF06B6D4);
  static const Color infoLight      = Color(0xFF083344);
  static const Color infoText       = Color(0xFF67E8F9);

  // ── Superficies oscuras (tema principal) ───────────────────────────────────
  static const Color background     = Color(0xFF09090B); // casi negro
  static const Color surface        = Color(0xFF111113); // cards
  static const Color surfaceElevated= Color(0xFF18181B); // modales, dropdowns
  static const Color surfaceHover   = Color(0xFF1F1F23); // hover states
  static const Color border         = Color(0xFF27272A); // bordes sutiles
  static const Color borderStrong   = Color(0xFF3F3F46); // bordes visibles

  // ── Sidebar ────────────────────────────────────────────────────────────────
  static const Color sidebarBg      = Color(0xFF0C0C0E);
  static const Color sidebarActive  = Color(0xFF1A1A2E); // fondo item activo
  static const Color sidebarBorder  = Color(0xFF1F1F23);

  // ── Texto ──────────────────────────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFFFAFAFA); // blanco suave
  static const Color textSecondary  = Color(0xFFA1A1AA); // gris medio
  static const Color textMuted      = Color(0xFF71717A); // gris apagado
  static const Color textDisabled   = Color(0xFF52525B);
  static const Color textInverse    = Color(0xFF09090B);

  // ── Superficies claras (modo light — opcional) ─────────────────────────────
  static const Color backgroundLight     = Color(0xFFFAFAFA);
  static const Color surfaceLight        = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF4F4F5);
  static const Color borderLight         = Color(0xFFE4E4E7);
  static const Color textPrimaryLight    = Color(0xFF09090B);
  static const Color textSecondaryLight  = Color(0xFF71717A);

  // ── Utilidades ─────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
}
