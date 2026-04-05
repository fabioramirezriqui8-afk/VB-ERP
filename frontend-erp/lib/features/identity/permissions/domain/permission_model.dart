/// Entidad de dominio — campos en inglés para consistencia con el backend
class PermissionModel {
  const PermissionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.module,
    required this.action,
  });

  final String id;
  final String name;        // "inventory:products:read"
  final String description;
  final String module;      // "inventory"
  final String action;      // "read"

  factory PermissionModel.fromJson(Map<String, dynamic> json) => PermissionModel(
    id:          json['id']          as String,
    name:        json['name']        as String,
    description: json['description'] as String? ?? '',
    module:      json['module']      as String,
    action:      json['action']      as String,
  );
}
