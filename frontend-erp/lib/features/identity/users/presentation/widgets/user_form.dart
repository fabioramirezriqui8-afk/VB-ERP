import 'package:flutter/material.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../roles/data/roles_repository.dart';
import '../../../roles/domain/role_model.dart';

class UserForm extends StatefulWidget {
  const UserForm({
    super.key,
    this.nombre,
    this.email,
    this.rolInicial,
    this.esEdicion = false,
    required this.onGuardar,
  });

  final String? nombre;
  final String? email;
  final String? rolInicial;
  final bool esEdicion;
  final void Function({
    required String nombre,
    required String email,
    required String rol,
    String? password,
  }) onGuardar;

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey       = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(text: widget.nombre);
  late final _emailCtrl  = TextEditingController(text: widget.email);
  final _passCtrl        = TextEditingController();

  String?        _rolSeleccionado;
  bool           _mostrarPass  = false;
  bool           _loadingRoles = true;
  List<RolModel> _roles        = [];

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final roles = await RolesRepository().listRoles();
      if (mounted) {
        setState(() {
          _roles        = roles;
          _loadingRoles = false;
          _rolSeleccionado = roles.isNotEmpty ? roles.first.id : null;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingRoles = false);
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onGuardar(
      nombre:   _nombreCtrl.text.trim(),
      email:    _emailCtrl.text.trim(),
      rol:      _rolSeleccionado!,
      password: widget.esEdicion ? null : _passCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFormSection(
            title: 'Datos personales',
            children: [
              Column(children: [
                AppFieldLabel(label: 'Nombre completo', isRequired: true),
                AppTextField(
                  controller: _nombreCtrl,
                  hint:       'Ej: Carlos Mendoza',
                  prefixIcon: Icons.person_outline,
                  validator:  (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
              ]),
              Column(children: [
                AppFieldLabel(label: 'Correo electrónico', isRequired: true),
                AppTextField(
                  controller:   _emailCtrl,
                  hint:         'correo@empresa.com',
                  prefixIcon:   Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  enabled:      !widget.esEdicion,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Requerido';
                    if (!RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-z]{2,}$').hasMatch(v.trim())) {
                      return 'Correo inválido';
                    }
                    return null;
                  },
                ),
              ]),
            ],
          ),

          AppFormSection(
            title: 'Acceso y permisos',
            children: [
              Column(children: [
                AppFieldLabel(label: 'Rol', isRequired: true),
                AppSelect<String>(
                  value:     _rolSeleccionado,
                  hint:      _loadingRoles ? 'Cargando roles...' : 'Seleccionar rol...',
                  enabled:   !_loadingRoles,
                  onChanged: (v) => setState(() => _rolSeleccionado = v),
                  options:   _roles.map((r) => AppSelectOption(
                    value: r.id,
                    label: r.nombre.replaceAll('_', ' '),
                  )).toList(),
                  validator: (v) => v == null ? 'Selecciona un rol' : null,
                ),
              ]),
            ],
          ),

          if (!widget.esEdicion)
            AppFormSection(
              title:       'Contraseña',
              description: 'Mínimo 8 caracteres.',
              children: [
                Column(children: [
                  AppFieldLabel(label: 'Contraseña', isRequired: true),
                  AppTextField(
                    controller:  _passCtrl,
                    obscureText: !_mostrarPass,
                    prefixIcon:  Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(_mostrarPass
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined, size: 18),
                      onPressed: () => setState(() => _mostrarPass = !_mostrarPass),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Requerido';
                      if (v.length < 8) return 'Mínimo 8 caracteres';
                      return null;
                    },
                  ),
                ]),
              ],
            ),

          const SizedBox(height: AppSpacing.xl2),
          AppButton(
            label:       widget.esEdicion ? 'Guardar cambios' : 'Crear usuario',
            onPressed:   _submit,
            isFullWidth: true,
            icon: widget.esEdicion ? Icons.save_outlined : Icons.person_add_outlined,
          ),
        ],
      ),
    );
  }
}
