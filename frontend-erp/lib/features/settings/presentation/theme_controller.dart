import 'package:flutter/material.dart';
import '../../../core/theme/app_theme_preset.dart';
import '../../../core/theme/app_theme_builder.dart';
import '../domain/i_theme_storage.dart';

/// Solo estado y lógica — sin UI ni persistencia directa
class ThemeController extends ChangeNotifier {
  ThemeController({required IThemeStorage storage}) : _storage = storage;

  final IThemeStorage _storage;

  AppThemePreset _preset = AppThemePresets.sovereignDark;

  AppThemePreset get preset   => _preset;
  ThemeMode      get mode     => _preset.mode;
  ThemeData      get themeData => AppThemeBuilder.build(_preset);

  /// Carga la preferencia guardada al iniciar
  Future<void> init() async {
    final saved = await _storage.load();
    if (saved != null) {
      _preset = saved;
      notifyListeners();
    }
  }

  /// Aplica un preset completo
  Future<void> applyPreset(AppThemePreset preset) async {
    _preset = preset;
    notifyListeners();
    await _storage.save(_preset);
  }

  /// Cambia solo el modo dark/light manteniendo los colores
  Future<void> setMode(ThemeMode mode) async {
    _preset = _preset.copyWith(mode: mode);
    notifyListeners();
    await _storage.save(_preset);
  }

  /// Cambia un token de color individual
  Future<void> setPrimary(Color color) async {
    _preset = _preset.copyWith(primary: color);
    notifyListeners();
    await _storage.save(_preset);
  }

  Future<void> setSecondary(Color color) async {
    _preset = _preset.copyWith(secondary: color);
    notifyListeners();
    await _storage.save(_preset);
  }

  Future<void> setTertiary(Color color) async {
    _preset = _preset.copyWith(tertiary: color);
    notifyListeners();
    await _storage.save(_preset);
  }

  Future<void> setNeutral(Color color) async {
    _preset = _preset.copyWith(neutral: color);
    notifyListeners();
    await _storage.save(_preset);
  }
}
