import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

abstract class AppTheme {
  // El ERP usa dark por defecto — más profesional y menos cansado
  static ThemeData get dark  => _buildDark();
  static ThemeData get light => _buildLight();

  // ── DARK (principal) ───────────────────────────────────────────────────────
  static ThemeData _buildDark() {
    const cs = ColorScheme(
      brightness:             Brightness.dark,
      primary:                AppColors.primary,
      onPrimary:              AppColors.white,
      primaryContainer:       AppColors.primaryGlow,
      onPrimaryContainer:     AppColors.primaryLight,
      secondary:              AppColors.secondary,
      onSecondary:            AppColors.white,
      secondaryContainer:     Color(0xFF2D1B69),
      onSecondaryContainer:   AppColors.secondaryLight,
      error:                  AppColors.error,
      onError:                AppColors.white,
      surface:                AppColors.surface,
      onSurface:              AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceElevated,
      outline:                AppColors.border,
      outlineVariant:         AppColors.borderStrong,
    );

    return ThemeData(
      useMaterial3:           true,
      brightness:             Brightness.dark,
      colorScheme:            cs,
      fontFamily:             AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.background,

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor:      AppColors.surface,
        foregroundColor:      AppColors.textPrimary,
        elevation:            0,
        scrolledUnderElevation: 0,
        systemOverlayStyle:   SystemUiOverlayStyle.light,
        titleTextStyle:       AppTypography.h4.copyWith(
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
      ),

      // ── Card ───────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color:     AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── ElevatedButton ─────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation:       0,
          shadowColor:     AppColors.primaryGlow,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: AppTypography.labelLg,
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.hovered) ? 4 : 0),
          shadowColor: WidgetStatePropertyAll(AppColors.primaryGlow),
        ),
      ),

      // ── OutlinedButton ─────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side:            const BorderSide(color: AppColors.borderStrong),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: AppTypography.labelLg,
        ),
      ),

      // ── TextButton ─────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: AppTypography.labelLg,
        ),
      ),

      // ── Input ──────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:      true,
        fillColor:   AppColors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle:  AppTypography.labelMd.copyWith(color: AppColors.textMuted),
        hintStyle:   AppTypography.bodyMd.copyWith(color: AppColors.textDisabled),
        errorStyle:  AppTypography.bodySm.copyWith(color: AppColors.errorText),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
      ),

      // ── Divider ────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color:     AppColors.border,
        thickness: 1,
        space:     1,
      ),

      // ── Chip ───────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevated,
        labelStyle:      AppTypography.labelMd.copyWith(color: AppColors.textSecondary),
        side:            const BorderSide(color: AppColors.border),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.chipRadius),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // ── SnackBar ───────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior:        SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceElevated,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: BorderSide(color: AppColors.borderStrong),
        ),
        contentTextStyle: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary),
      ),

      // ── Dialog ─────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceElevated,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.dialogRadius,
          side: BorderSide(color: AppColors.border),
        ),
        elevation: 24,
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.textPrimary),
      ),

      // ── IconButton ─────────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
        ),
      ),

      // ── ListTile ───────────────────────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        textColor:  AppColors.textPrimary,
        iconColor:  AppColors.textSecondary,
        tileColor:  Colors.transparent,
      ),

      // ── TabBar ─────────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor:          AppColors.primary,
        unselectedLabelColor: AppColors.textMuted,
        indicatorColor:      AppColors.primary,
        dividerColor:        AppColors.border,
        labelStyle:          AppTypography.labelMd,
        unselectedLabelStyle: AppTypography.labelMd,
      ),

      // ── Scrollbar ──────────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(AppColors.borderStrong),
        radius:     const Radius.circular(4),
        thickness:  WidgetStatePropertyAll(4),
      ),
    );
  }

  // ── LIGHT (opcional) ───────────────────────────────────────────────────────
  static ThemeData _buildLight() {
    const cs = ColorScheme(
      brightness:   Brightness.light,
      primary:      AppColors.primaryDark,
      onPrimary:    AppColors.white,
      secondary:    AppColors.secondaryDark,
      onSecondary:  AppColors.white,
      error:        AppColors.error,
      onError:      AppColors.white,
      surface:      AppColors.surfaceLight,
      onSurface:    AppColors.textPrimaryLight,
      outline:      AppColors.borderLight,
      outlineVariant: Color(0xFFD4D4D8),
    );

    return ThemeData(
      useMaterial3:            true,
      brightness:              Brightness.light,
      colorScheme:             cs,
      fontFamily:              AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardTheme: CardThemeData(
        color:     AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: const BorderSide(color: AppColors.borderLight),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled:    true,
        fillColor: AppColors.surfaceVariantLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}
