class UsuarioModel {
  const UsuarioModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.roles,
    required this.activo,
    required this.creadoEn,
  });

  final String       id;
  final String       nombre;
  final String       email;
  final List<String> roles;
  final bool         activo;
  final DateTime     creadoEn;

  factory UsuarioModel.fromJson(Map<String, dynamic> j) => UsuarioModel(
    id:       j['id']    as String,
    nombre:   j['name']  as String,
    email:    j['email'] as String,
    roles:    List<String>.from(j['roles'] as List? ?? []),
    activo:   j['active'] as bool? ?? true,
    creadoEn: DateTime.tryParse(j['created_at'] as String? ?? '') ?? DateTime.now(),
  );

  UsuarioModel copyWith({String? nombre, String? email, List<String>? roles, bool? activo}) =>
      UsuarioModel(
        id:       id,
        nombre:   nombre ?? this.nombre,
        email:    email  ?? this.email,
        roles:    roles  ?? this.roles,
        activo:   activo ?? this.activo,
        creadoEn: creadoEn,
      );
}
