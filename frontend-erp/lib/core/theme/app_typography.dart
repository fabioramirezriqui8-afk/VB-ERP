import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tipografía global del ERP.
abstract class AppTypography {
  static const String fontFamily = 'Inter';

  // ── Display ────────────────────────────────────────────────────────────────
  static const TextStyle displayLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48, fontWeight: FontWeight.w700,
    letterSpacing: -0.5, height: 1.1,
  );
  static const TextStyle displayMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36, fontWeight: FontWeight.w700,
    letterSpacing: -0.3, height: 1.2,
  );

  // ── Headings ───────────────────────────────────────────────────────────────
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30, fontWeight: FontWeight.w700,
    letterSpacing: -0.2, height: 1.3,
  );
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24, fontWeight: FontWeight.w600,
    height: 1.35,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20, fontWeight: FontWeight.w600,
    height: 1.4,
  );
  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18, fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ── Body ───────────────────────────────────────────────────────────────────
  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16, fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12, fontWeight: FontWeight.w400,
    height: 1.5, color: AppColors.textSecondary,
  );

  // ── Label / UI ─────────────────────────────────────────────────────────────
  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14, fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12, fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static const TextStyle labelSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11, fontWeight: FontWeight.w500,
    letterSpacing: 0.3, color: AppColors.textSecondary,
  );

  // ── Caption / Overline ─────────────────────────────────────────────────────
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11, fontWeight: FontWeight.w400,
    height: 1.4, color: AppColors.textSecondary,
  );
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10, fontWeight: FontWeight.w600,
    letterSpacing: 1.2, color: AppColors.textSecondary,
  );

  // ── Code ───────────────────────────────────────────────────────────────────
  static const TextStyle code = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13, fontWeight: FontWeight.w400,
    height: 1.5,
  );
}
