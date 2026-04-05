class RolModel {
  const RolModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.permisos,
    required this.creadoEn,
  });

  final String       id;
  final String       nombre;
  final String       descripcion;
  final List<String> permisos;
  final DateTime     creadoEn;

  int get totalPermisos => permisos.length;

  factory RolModel.fromJson(Map<String, dynamic> j) => RolModel(
    id:          j['id']          as String,
    nombre:      j['name']        as String,
    descripcion: j['description'] as String? ?? '',
    permisos:    List<String>.from(j['permissions'] as List? ?? []),
    creadoEn:    DateTime.tryParse(j['created_at'] as String? ?? '') ?? DateTime.now(),
  );

  RolModel copyWith({String? nombre, String? descripcion, List<String>? permisos}) =>
      RolModel(
        id:          id,
        nombre:      nombre      ?? this.nombre,
        descripcion: descripcion ?? this.descripcion,
        permisos:    permisos    ?? this.permisos,
        creadoEn:    creadoEn,
      );
}
