import '../../../core/theme/app_theme_preset.dart';

/// Contrato — el controller solo conoce esta interfaz
abstract interface class IThemeStorage {
  Future<AppThemePreset?> load();
  Future<void> save(AppThemePreset preset);
}
