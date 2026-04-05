import 'package:flutter/foundation.dart';
import '../../domain/auth_model.dart';
import '../../domain/i_auth_repository.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_mock_repository.dart';

/// Estado del login — solo lógica, cero widgets
enum LoginStatus { idle, loading, success, error }

class LoginController extends ChangeNotifier {
  LoginController({required IAuthRepository repository})
      : _repo = repository;

  final IAuthRepository _repo;

  LoginStatus _status  = LoginStatus.idle;
  String?     _error;
  AuthTokens? _tokens;

  LoginStatus get status => _status;
  String?     get error  => _error;
  AuthTokens? get tokens => _tokens;
  bool get isLoading     => _status == LoginStatus.loading;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _status = LoginStatus.loading;
    _error  = null;
    notifyListeners();

    try {
      _tokens = await _repo.login(email: email, password: password);
      _status = LoginStatus.success;
    } on AuthException catch (e) {
      _error  = e.message;
      _status = LoginStatus.error;
    } on AuthMockException catch (e) {
      _error  = e.message;
      _status = LoginStatus.error;
    } catch (_) {
      _error  = 'Error de conexión. Verifica tu red.';
      _status = LoginStatus.error;
    }

    notifyListeners();
  }
}
