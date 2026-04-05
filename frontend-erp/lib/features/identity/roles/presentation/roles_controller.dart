import 'package:flutter/foundation.dart';
import '../data/roles_repository.dart';
import '../domain/role_model.dart';

class RolesController extends ChangeNotifier {
  RolesController({RolesRepository? repository})
      : _repository = repository ?? RolesRepository();

  final RolesRepository _repository;

  List<RolModel> _todos     = [];
  List<RolModel> _filtrados = [];
  bool    _isLoading = false;
  String? _error;

  List<RolModel> get filtrados => _filtrados;
  List<RolModel> get todos     => _todos;
  bool           get isLoading => _isLoading;
  String?        get error     => _error;

  Future<void> loadRoles() async {
    _isLoading = true;
    _error     = null;
    notifyListeners();
    try {
      _todos     = await _repository.listRoles();
      _filtrados = List.from(_todos);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void buscar(String q) {
    _filtrados = _todos.where((r) =>
      r.nombre.toLowerCase().contains(q.toLowerCase()) ||
      r.descripcion.toLowerCase().contains(q.toLowerCase())
    ).toList();
    notifyListeners();
  }

  void crear({required String nombre, required String descripcion, required List<String> permisos}) {}
  void editar(RolModel rol, {required String nombre, required String descripcion, required List<String> permisos}) {}
  void eliminar(String id) {}
}
