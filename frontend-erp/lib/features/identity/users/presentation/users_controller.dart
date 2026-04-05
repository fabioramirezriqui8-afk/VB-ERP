import 'package:flutter/foundation.dart';
import '../data/users_repository.dart';
import '../domain/user_model.dart';

class UsuariosController extends ChangeNotifier {
  UsuariosController({UsersRepository? repository})
      : _repository = repository ?? UsersRepository();

  final UsersRepository _repository;

  List<UsuarioModel> _todos     = [];
  List<UsuarioModel> _filtrados = [];
  String  _busqueda    = '';
  String? _filtroEstado;
  bool    _isLoading   = false;
  String? _error;

  List<UsuarioModel> get filtrados    => _filtrados;
  List<UsuarioModel> get todos        => _todos;
  String?            get filtroEstado => _filtroEstado;
  bool               get isLoading    => _isLoading;
  String?            get error        => _error;

  Future<void> loadUsers() async {
    _isLoading = true;
    _error     = null;
    notifyListeners();
    try {
      _todos = await _repository.listUsers();
      _aplicarFiltros();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void buscar(String q) {
    _busqueda = q;
    _aplicarFiltros();
  }

  void filtrarEstado(String? estado) {
    _filtroEstado = estado;
    _aplicarFiltros();
  }

  void limpiarFiltros() {
    _busqueda     = '';
    _filtroEstado = null;
    _aplicarFiltros();
  }

  Future<void> crear({
    required String nombre,
    required String email,
    required String rol,
    required String password,
  }) async {
    _isLoading = true;
    _error     = null;
    notifyListeners();
    try {
      await _repository.createUser(
        name: nombre, email: email, password: password, roleId: rol,
      );
      await loadUsers();
    } catch (e) {
      _error     = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void editar(UsuarioModel usuario, {required String nombre, required String rol}) {}
  void toggleEstado(UsuarioModel usuario) {}
  void eliminar(String id) {}

  void _aplicarFiltros() {
    _filtrados = _todos.where((u) {
      final matchQ = _busqueda.isEmpty ||
          u.nombre.toLowerCase().contains(_busqueda.toLowerCase()) ||
          u.email.toLowerCase().contains(_busqueda.toLowerCase());
      final matchE = _filtroEstado == null ||
          (_filtroEstado == 'Activo' ? u.activo : !u.activo);
      return matchQ && matchE;
    }).toList();
    notifyListeners();
  }
}
