import 'package:flutter/material.dart';

/// Modelo puro — solo datos, sin lógica ni UI
class AppThemePreset {
  const AppThemePreset({
    required this.id,
    required this.name,
    required this.mode,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.neutral,
  });

  final String    id;
  final String    name;
  final ThemeMode mode;
  final Color     primary;
  final Color     secondary;
  final Color     tertiary;
  final Color     neutral;   // fondo base

  AppThemePreset copyWith({
    ThemeMode? mode,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? neutral,
  }) => AppThemePreset(
    id:        id,
    name:      name,
    mode:      mode      ?? this.mode,
    primary:   primary   ?? this.primary,
    secondary: secondary ?? this.secondary,
    tertiary:  tertiary  ?? this.tertiary,
    neutral:   neutral   ?? this.neutral,
  );

  Map<String, dynamic> toJson() => {
    'id':        id,
    'name':      name,
    'mode':      mode.index,
    'primary':   primary.value,
    'secondary': secondary.value,
    'tertiary':  tertiary.value,
    'neutral':   neutral.value,
  };

  factory AppThemePreset.fromJson(Map<String, dynamic> j) => AppThemePreset(
    id:        j['id'] as String,
    name:      j['name'] as String,
    mode:      ThemeMode.values[j['mode'] as int],
    primary:   Color(j['primary'] as int),
    secondary: Color(j['secondary'] as int),
    tertiary:  Color(j['tertiary'] as int),
    neutral:   Color(j['neutral'] as int),
  );
}

/// Presets predefinidos del sistema
abstract class AppThemePresets {
  static const sovereignDark = AppThemePreset(
    id:        'sovereign_dark',
    name:      'Sovereign Dark',
    mode:      ThemeMode.dark,
    primary:   Color(0xFF4A148C),
    secondary: Color(0xFFB0BEC5),
    tertiary:  Color(0xFFE1BEE7),
    neutral:   Color(0xFF121212),
  );

  static const cleanLight = AppThemePreset(
    id:        'clean_light',
    name:      'Clean Light',
    mode:      ThemeMode.light,
    primary:   Color(0xFF4A148C),
    secondary: Color(0xFF546E7A),
    tertiary:  Color(0xFFCE93D8),
    neutral:   Color(0xFFFFFFFF),
  );

  static const ocean = AppThemePreset(
    id:        'ocean',
    name:      'Ocean',
    mode:      ThemeMode.dark,
    primary:   Color(0xFF0284C7),
    secondary: Color(0xFF94A3B8),
    tertiary:  Color(0xFF7DD3FC),
    neutral:   Color(0xFF0A1628),
  );

  static const slate = AppThemePreset(
    id:        'slate',
    name:      'Slate',
    mode:      ThemeMode.light,
    primary:   Color(0xFF6366F1),
    secondary: Color(0xFF64748B),
    tertiary:  Color(0xFFA5B4FC),
    neutral:   Color(0xFFF8FAFC),
  );

  static const List<AppThemePreset> all = [
    sovereignDark,
    cleanLight,
    ocean,
    slate,
  ];
}
