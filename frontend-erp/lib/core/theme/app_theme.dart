import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

abstract class AppTheme {
  static ThemeData get light => _build();

  static ThemeData _build() {
    const cs = ColorScheme(
      brightness:              Brightness.light,
      primary:                 AppColors.accent,
      onPrimary:               AppColors.white,
      primaryContainer:        AppColors.accentLight,
      onPrimaryContainer:      AppColors.primary,
      secondary:               AppColors.secondary,
      onSecondary:             AppColors.white,
      secondaryContainer:      AppColors.surfaceVariant,
      onSecondaryContainer:    AppColors.textPrimary,
      error:                   AppColors.error,
      onError:                 AppColors.white,
      surface:                 AppColors.surface,
      onSurface:               AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      surfaceContainerHigh:    AppColors.surfaceHover,
      surfaceContainer:        AppColors.background,
      surfaceContainerLow:     AppColors.background,
      surfaceContainerLowest:  AppColors.background,
      outline:                 AppColors.border,
      outlineVariant:          AppColors.border,
    );

    return ThemeData(
      useMaterial3:            true,
      brightness:              Brightness.light,
      colorScheme:             cs,
      fontFamily:              AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: AppBarTheme(
        backgroundColor:        AppColors.surface,
        foregroundColor:        AppColors.textPrimary,
        elevation:              0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        iconTheme: const IconThemeData(color: AppColors.secondary),
        shadowColor: AppColors.border,
      ),

      cardTheme: CardThemeData(
        color:     AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // Botón primario — azul brillante
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
          elevation:       0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.labelLg,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.labelLg,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: AppTypography.labelLg,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled:         true,
        fillColor:      AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle:      AppTypography.labelMd.copyWith(color: AppColors.textSecondary),
        hintStyle:       AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
      ),

      dividerTheme: const DividerThemeData(
        color:     AppColors.border,
        thickness: 1,
        space:     1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.accentLight,
        labelStyle: AppTypography.labelMd.copyWith(color: AppColors.accent),
        side: BorderSide.none,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
          side: const BorderSide(color: AppColors.border),
        ),
        elevation: 0,
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.textPrimary),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor:           AppColors.accent,
        unselectedLabelColor: AppColors.textMuted,
        indicatorColor:       AppColors.accent,
        dividerColor:         Colors.transparent,
        labelStyle:           AppTypography.labelMd,
        unselectedLabelStyle: AppTypography.labelMd,
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.secondary),
      ),

      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimary,
        iconColor: AppColors.secondary,
        tileColor: Colors.transparent,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior:        SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        contentTextStyle: AppTypography.bodyMd.copyWith(color: AppColors.white),
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbColor: const WidgetStatePropertyAll(AppColors.borderStrong),
        radius:    const Radius.circular(4),
        thickness: const WidgetStatePropertyAll(3),
      ),
    );
  }
}
