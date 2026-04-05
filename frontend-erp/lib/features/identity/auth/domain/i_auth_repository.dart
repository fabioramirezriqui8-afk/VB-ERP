import 'auth_model.dart';

/// Contrato — la presentación solo conoce esta interfaz, nunca la implementación
abstract interface class IAuthRepository {
  Future<AuthTokens> login({required String email, required String password});
  Future<void> logout();
  Future<AuthTokens?> restoreSession(); // lee token guardado
}
