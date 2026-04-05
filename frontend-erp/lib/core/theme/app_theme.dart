import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

abstract class AppTheme {
  static ThemeData get dark  => _buildDark();
  static ThemeData get light => _buildDark(); // solo dark mode

  static ThemeData _buildDark() {
    const cs = ColorScheme(
      brightness:              Brightness.dark,
      primary:                 AppColors.primary,
      onPrimary:               AppColors.onPrimary,
      primaryContainer:        AppColors.primaryContainer,
      onPrimaryContainer:      AppColors.onPrimaryContainer,
      secondary:               AppColors.secondary,
      onSecondary:             AppColors.onSecondary,
      secondaryContainer:      AppColors.secondaryContainer,
      onSecondaryContainer:    AppColors.onSurface,
      error:                   AppColors.error,
      onError:                 AppColors.onPrimary,
      surface:                 AppColors.surfaceLow,
      onSurface:               AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceHighest,
      surfaceContainerHigh:    AppColors.surfaceHigh,
      surfaceContainer:        AppColors.surface,
      surfaceContainerLow:     AppColors.surfaceLow,
      surfaceContainerLowest:  AppColors.surfaceLowest,
      outline:                 AppColors.outlineVariant,
      outlineVariant:          AppColors.outlineVariant,
    );

    return ThemeData(
      useMaterial3:            true,
      brightness:              Brightness.dark,
      colorScheme:             cs,
      fontFamily:              AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.surfaceLowest,

      // ── AppBar — sin línea inferior ────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor:        AppColors.surfaceLow,
        foregroundColor:        AppColors.onSurface,
        elevation:              0,
        scrolledUnderElevation: 0,
        systemOverlayStyle:     SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.h4.copyWith(color: AppColors.onSurface),
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),

      // ── Card — sin borde, solo cambio tonal ───────────────────────────────
      cardTheme: CardThemeData(
        color:     AppColors.surfaceLow,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        margin: EdgeInsets.zero,
      ),

      // ── ElevatedButton — gradiente violeta ────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.button),
          ),
          textStyle: WidgetStatePropertyAll(AppTypography.labelLg),
          foregroundColor: const WidgetStatePropertyAll(AppColors.onPrimary),
          backgroundColor: WidgetStatePropertyAll(AppColors.primaryContainer),
          overlayColor: WidgetStatePropertyAll(
            AppColors.primaryFixedVariant.withOpacity(0.3),
          ),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),

      // ── OutlinedButton — ghost border ─────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.outlineVariant.withOpacity(0.20)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.labelLg,
        ),
      ),

      // ── TextButton ────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: AppTypography.labelLg,
        ),
      ),

      // ── Input — solo borde inferior, sin caja ─────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:         true,
        fillColor:      AppColors.surfaceLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        // Sin borde en 4 lados — solo bottom border
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant, width: 1.5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.error.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle:      AppTypography.labelMd.copyWith(color: AppColors.textMuted),
        hintStyle:       AppTypography.bodyMd.copyWith(color: AppColors.textDisabled),
        errorStyle:      AppTypography.bodySm.copyWith(color: AppColors.error),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
      ),

      // ── Divider — prohibido por el design system, mínimo uso ──────────────
      dividerTheme: DividerThemeData(
        color:     AppColors.outlineVariant.withOpacity(0.15),
        thickness: 1,
        space:     1,
      ),

      // ── Chip ──────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceHighest,
        labelStyle: AppTypography.labelMd.copyWith(color: AppColors.secondary),
        side:        BorderSide.none,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // ── SnackBar — glass ──────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior:        SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceHigh.withOpacity(0.90),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: AppColors.outlineVariant.withOpacity(0.15)),
        ),
        contentTextStyle: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
      ),

      // ── Dialog — glassmorphism ─────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceHigh.withOpacity(0.70),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
          side: BorderSide(color: AppColors.outlineVariant.withOpacity(0.15)),
        ),
        elevation: 0,
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.onSurface),
      ),

      // ── IconButton ────────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.secondary),
      ),

      // ── ListTile — sin dividers ────────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        textColor:  AppColors.onSurface,
        iconColor:  AppColors.secondary,
        tileColor:  Colors.transparent,
      ),

      // ── TabBar ────────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor:           AppColors.primary,
        unselectedLabelColor: AppColors.textMuted,
        indicatorColor:       AppColors.primary,
        dividerColor:         Colors.transparent, // sin línea
        labelStyle:           AppTypography.labelMd,
        unselectedLabelStyle: AppTypography.labelMd,
      ),

      // ── Scrollbar ─────────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          AppColors.outlineVariant.withOpacity(0.4),
        ),
        radius:    const Radius.circular(4),
        thickness: const WidgetStatePropertyAll(3),
      ),
    );
  }
}
