import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme_preset.dart';
import '../domain/i_theme_storage.dart';

/// Solo persistencia — sin lógica de negocio ni UI
class ThemeStorage implements IThemeStorage {
  static const _key = 'app_theme_preset';

  @override
  Future<AppThemePreset?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return AppThemePreset.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(AppThemePreset preset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(preset.toJson()));
  }
}
