import 'package:flutter/material.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../permissions/data/permissions_repository.dart';
import '../../../permissions/domain/permission_model.dart';

class RolForm extends StatefulWidget {
  const RolForm({
    super.key,
    this.nombre,
    this.descripcion,
    this.permisosSeleccionados = const [],
    this.esEdicion = false,
    required this.onGuardar,
  });

  final String? nombre;
  final String? descripcion;
  final List<String> permisosSeleccionados;
  final bool esEdicion;
  final void Function({
    required String nombre,
    required String descripcion,
    required List<String> permisos,
  }) onGuardar;

  @override
  State<RolForm> createState() => _RolFormState();
}

class _RolFormState extends State<RolForm> {
  final _formKey   = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(text: widget.nombre);
  late final _descCtrl   = TextEditingController(text: widget.descripcion);
  late Set<String> _seleccionados;
  List<PermissionModel> _todosPermisos = [];
  bool _loadingPermisos = true;
  Map<String, List<PermissionModel>> _grupos = {};

  @override
  void initState() {
    super.initState();
    _seleccionados = Set.from(widget.permisosSeleccionados);
    _loadPermisos();
  }

  Future<void> _loadPermisos() async {
    try {
      final perms = await PermissionsRepository().listPermissions();
      if (mounted) {
        final mapa = <String, List<PermissionModel>>{};
        for (final p in perms) { mapa.putIfAbsent(p.module, () => []).add(p); }
        setState(() { _todosPermisos = perms; _grupos = mapa; _loadingPermisos = false; });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingPermisos = false);
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onGuardar(
      nombre:      _nombreCtrl.text.trim(),
      descripcion: _descCtrl.text.trim(),
      permisos:    _seleccionados.toList(),
    );
  }

  String _labelModulo(String modulo) => switch (modulo) {
    'identity'   => 'Identidad',
    'inventory'  => 'Inventario',
    'billing'    => 'Facturación',
    'purchasing' => 'Compras',
    'crm'        => 'CRM',
    'finance'    => 'Finanzas',
    'hr'         => 'RRHH',
    'reports'    => 'Reportes',
    _            => modulo,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Datos del rol ─────────────────────────────────────────────
          AppFormSection(
            title: 'Información del rol',
            children: [
              Column(children: [
                AppFieldLabel(label: 'Nombre del rol', isRequired: true),
                AppTextField(
                  controller: _nombreCtrl,
                  hint:       'Ej: gerente_ventas',
                  prefixIcon: Icons.shield_outlined,
                  validator:  (v) => v == null || v.trim().isEmpty
                      ? 'El nombre es requerido' : null,
                ),
              ]),
              Column(children: [
                AppFieldLabel(label: 'Descripción', isRequired: false),
                AppTextField(
                  controller: _descCtrl,
                  hint:       'Describe las responsabilidades de este rol',
                  maxLines:   2,
                ),
              ]),
            ],
          ),

          // ── Permisos ──────────────────────────────────────────────────
          AppFormSection(
            title: 'Permisos asignados',
            description: '${_seleccionados.length} permisos seleccionados',
            children: [
              ..._grupos.entries.map((entry) => _GrupoPermisos(
                modulo:        entry.key,
                labelModulo:   _labelModulo(entry.key),
                permisos:      entry.value,
                seleccionados: _seleccionados,
                onToggle: (name, val) => setState(() {
                  val ? _seleccionados.add(name) : _seleccionados.remove(name);
                }),
                onToggleAll: (todos) => setState(() {
                  final names = entry.value.map((p) => p.name).toSet();
                  todos
                      ? _seleccionados.addAll(names)
                      : _seleccionados.removeAll(names);
                }),
              )),
            ],
          ),

          const SizedBox(height: AppSpacing.xl2),
          AppButton(
            label:       widget.esEdicion ? 'Guardar cambios' : 'Crear rol',
            onPressed:   _submit,
            isFullWidth: true,
            icon:        Icons.shield_outlined,
          ),
        ],
      ),
    );
  }
}

class _GrupoPermisos extends StatelessWidget {
  const _GrupoPermisos({
    required this.modulo,
    required this.labelModulo,
    required this.permisos,
    required this.seleccionados,
    required this.onToggle,
    required this.onToggleAll,
  });

  final String modulo;
  final String labelModulo;
  final List<PermissionModel> permisos;
  final Set<String> seleccionados;
  final void Function(String name, bool val) onToggle;
  final void Function(bool todos) onToggleAll;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final todosSeleccionados = permisos.every((p) => seleccionados.contains(p.name));
    final algunoSeleccionado = permisos.any((p) => seleccionados.contains(p.name));

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color:        cs.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => onToggleAll(!todosSeleccionados),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                children: [
                  Checkbox(
                    value:     todosSeleccionados ? true : (algunoSeleccionado ? null : false),
                    tristate:  true,
                    onChanged: (v) => onToggleAll(v ?? false),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(labelModulo, style: AppTypography.labelLg),
                  const Spacer(),
                  Text(
                    '${permisos.where((p) => seleccionados.contains(p.name)).length}/${permisos.length}',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          ...permisos.map((p) => CheckboxListTile(
            value:     seleccionados.contains(p.name),
            onChanged: (v) => onToggle(p.name, v ?? false),
            title:     Text(p.description, style: AppTypography.bodyMd),
            subtitle:  Text(p.name, style: AppTypography.caption),
            dense:     true,
            controlAffinity: ListTileControlAffinity.leading,
          )),
        ],
      ),
    );
  }
}
