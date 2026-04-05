import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import '../data/users_repository.dart';
import '../domain/user_model.dart';
import '../../../../shared/widgets/filters/app_filter_def.dart';

class UsuariosController extends ChangeNotifier {
  UsuariosController({UsersRepository? repository})
      : _repository = repository ?? UsersRepository();

  final UsersRepository _repository;

  List<UsuarioModel> _todos     = [];
  List<UsuarioModel> _filtrados = [];
  String  _busqueda    = '';
  List<AppFilterValue> _filtros = [];
  bool    _isLoading   = false;
  String? _error;

  List<UsuarioModel>   get filtrados => _filtrados;
  List<UsuarioModel>   get todos     => _todos;
  List<AppFilterValue> get filtros   => _filtros;
  bool                 get isLoading => _isLoading;
  String?              get error     => _error;

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

  void aplicarFiltros(List<AppFilterValue> valores) {
    _filtros = valores;
    _aplicarFiltros();
  }

  void limpiarFiltros() {
    _busqueda = '';
    _filtros  = [];
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
      // Búsqueda por texto
      if (_busqueda.isNotEmpty) {
        final q = _busqueda.toLowerCase();
        if (!u.nombre.toLowerCase().contains(q) &&
            !u.email.toLowerCase().contains(q)) return false;
      }

      // Filtros del panel
      for (final f in _filtros) {
        switch (f.key) {
          case 'estado':
            final activo = f.rawValue == 'Activo';
            if (u.activo != activo) return false;
          case 'fecha':
            if (f.rawValue is DateTimeRange) {
              final range = f.rawValue as DateTimeRange;
              if (u.creadoEn.isBefore(range.start) ||
                  u.creadoEn.isAfter(range.end)) return false;
            }
        }
      }
      return true;
    }).toList();
    notifyListeners();
  }
}
