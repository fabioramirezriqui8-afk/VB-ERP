import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../domain/role_model.dart';
import 'roles_controller.dart';
import 'widgets/role_detail_modal.dart';
import 'widgets/role_form.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final _ctrl       = RolesController();
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onCtrlChange);
    _ctrl.loadRoles();
  }

  void _onCtrlChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onCtrlChange);
    _ctrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _verDetalle(RolModel r) {
    RoleDetailModal.show(context,
      rol:      r,
      onEditar: () { Navigator.of(context).pop(); _abrirFormulario(rol: r); },
    );
  }

  void _abrirFormulario({RolModel? rol}) {
    AppSideSheet.show(
      context:     context,
      title:       rol == null ? 'Nuevo rol' : 'Editar rol',
      subtitle:    rol == null ? 'Define nombre y permisos del nuevo rol' : 'Modifica los permisos',
      showActions: false,
      child: RolForm(
        nombre:                rol?.nombre,
        descripcion:           rol?.descripcion,
        permisosSeleccionados: rol?.permisos ?? [],
        esEdicion:             rol != null,
        onGuardar: ({required nombre, required descripcion, required permisos}) {
          if (rol == null) {
            _ctrl.crear(nombre: nombre, descripcion: descripcion, permisos: permisos);
            _ok('Rol "$nombre" creado');
          } else {
            _ctrl.editar(rol, nombre: nombre, descripcion: descripcion, permisos: permisos);
            _ok('Rol actualizado');
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _eliminar(RolModel r) async {
    final ok = await AppConfirmDialog.delete(
      context:  context,
      itemName: 'rol',
      detail:   '"${r.nombre}" — ${r.descripcion}',
    );
    if (ok == true && mounted) { _ctrl.eliminar(r.id); _ok('Rol eliminado'); }
  }

  void _ok(String msg) =>
      AppSnackbar.show(context, message: msg, type: SnackbarType.success);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Topbar ────────────────────────────────────────────────────
        Container(
          width:   double.infinity,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl2, AppSpacing.xl2, AppSpacing.xl2, AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(
              bottom: BorderSide(color: cs.outline.withOpacity(0.12)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBreadcrumb(items: const [
                BreadcrumbItem(label: 'Inicio', route: '/dashboard'),
                BreadcrumbItem(label: 'Roles'),
              ]),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.md,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Gestión de Roles', style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${_ctrl.todos.length} roles configurados en el sistema',
                        style: AppTypography.bodyMd.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  AppButton(
                    label:     'Nuevo rol',
                    icon:      Icons.shield_outlined,
                    onPressed: () => _abrirFormulario(),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Filtros ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl2, AppSpacing.xl2, AppSpacing.xl2, 0,
          ),
          child: AppFilterBar(
            searchHint:       'Buscar rol por nombre o descripción...',
            searchController: _searchCtrl,
            onSearchChanged:  _ctrl.buscar,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Tabla ─────────────────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
            child: AppTable<RolModel>(
              rows:             _ctrl.filtrados,
              emptyTitle:       'Sin roles',
              emptyDescription: 'Crea el primer rol con el botón "Nuevo rol"',
              emptyIcon:        Icons.shield_outlined,
              totalItems:       _ctrl.filtrados.length,
              currentPage:      1,
              pageSize:         20,
              onRowTap:         _verDetalle,
              columns: [
                AppTableColumn<RolModel>(
                  label: 'Nombre del rol',
                  flex:  2,
                  builder: (r) => Row(
                    children: [
                      Container(
                        width:  36, height: 36,
                        decoration: BoxDecoration(
                          color:        cs.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.shield_outlined, size: 18, color: cs.primary),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          r.nombre.replaceAll('_', ' '),
                          style: AppTypography.labelMd,
                        ),
                      ),
                    ],
                  ),
                ),
                AppTableColumn<RolModel>(
                  label: 'Descripción',
                  flex:  3,
                  builder: (r) => Text(r.descripcion, style: AppTypography.bodyMd),
                ),
                AppTableColumn<RolModel>(
                  label: 'Permisos',
                  flex:  1,
                  builder: (r) => AppBadge(
                    label:   '${r.totalPermisos}',
                    variant: AppBadgeVariant.info,
                    icon:    Icons.lock_outline,
                  ),
                ),
                AppTableColumn<RolModel>(
                  label:     'Acciones',
                  flex:      1,
                  alignment: Alignment.center,
                  builder:   (r) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:      const Icon(Icons.edit_outlined, size: 18),
                        tooltip:   'Editar',
                        onPressed: () => _abrirFormulario(rol: r),
                      ),
                      IconButton(
                        icon:      const Icon(Icons.delete_outline, size: 18),
                        color:     cs.error,
                        tooltip:   'Eliminar',
                        onPressed: () => _eliminar(r),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
