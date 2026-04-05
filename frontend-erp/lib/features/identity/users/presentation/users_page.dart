import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../domain/user_model.dart';
import 'users_controller.dart';
import 'widgets/user_detail_modal.dart';
import 'widgets/user_form.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final _ctrl       = UsuariosController();
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onCtrlChange);
    _ctrl.loadUsers();
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

  void _verDetalle(UsuarioModel u) {
    UserDetailModal.show(context,
      usuario:  u,
      onEditar: () { Navigator.of(context).pop(); _abrirFormulario(usuario: u); },
    );
  }

  void _abrirFormulario({UsuarioModel? usuario}) {
    AppSideSheet.show(
      context:     context,
      title:       usuario == null ? 'Nuevo usuario' : 'Editar usuario',
      subtitle:    usuario == null ? 'Completa los datos del nuevo usuario' : 'Modifica los datos',
      showActions: false,
      child: UserForm(
        nombre:     usuario?.nombre,
        email:      usuario?.email,
        rolInicial: usuario?.roles.firstOrNull,
        esEdicion:  usuario != null,
        onGuardar: ({required nombre, required email, required rol, password}) async {
          if (usuario == null) {
            try {
              await _ctrl.crear(nombre: nombre, email: email, rol: rol, password: password!);
              if (mounted) {
                _ok('Usuario "$nombre" creado');
                Navigator.of(context).pop();
              }
            } catch (e) {
              if (mounted) AppSnackbar.show(context, message: 'Error: $e', type: SnackbarType.error);
            }
          } else {
            _ctrl.editar(usuario, nombre: nombre, rol: rol);
            _ok('Usuario actualizado');
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Future<void> _eliminar(UsuarioModel u) async {
    final ok = await AppConfirmDialog.delete(
      context:  context,
      itemName: 'usuario',
      detail:   '"${u.nombre}" — ${u.email}',
    );
    if (ok == true && mounted) { _ctrl.eliminar(u.id); _ok('Usuario eliminado'); }
  }

  void _ok(String msg) =>
      AppSnackbar.show(context, message: msg, type: SnackbarType.success);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Topbar de la sección ──────────────────────────────────────
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
                BreadcrumbItem(label: 'Inicio',   route: '/dashboard'),
                BreadcrumbItem(label: 'Usuarios'),
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
                      Text('Gestión de Usuarios', style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${_ctrl.todos.length} usuarios registrados en el sistema',
                        style: AppTypography.bodyMd.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  AppButton(
                    label:     'Nuevo usuario',
                    icon:      Icons.person_add_outlined,
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
            searchHint:       'Buscar por nombre o correo...',
            searchController: _searchCtrl,
            onSearchChanged:  _ctrl.buscar,
            activeFilters: _ctrl.filtroEstado != null
                ? [ActiveFilter(key: 'estado', label: 'Estado', value: _ctrl.filtroEstado!)]
                : [],
            onRemoveFilter: (_) { _ctrl.limpiarFiltros(); _searchCtrl.clear(); },
            onClearAll:     ()  { _ctrl.limpiarFiltros(); _searchCtrl.clear(); },
            onAdvancedFilter: _mostrarFiltros,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Tabla ─────────────────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
            child: AppTable<UsuarioModel>(
              rows:             _ctrl.filtrados,
              emptyTitle:       'Sin usuarios',
              emptyDescription: 'Crea el primer usuario con el botón "Nuevo usuario"',
              emptyIcon:        Icons.people_outline,
              totalItems:       _ctrl.filtrados.length,
              currentPage:      1,
              pageSize:         20,
              onRowTap:         _verDetalle,
              columns: [
                AppTableColumn<UsuarioModel>(
                  label: 'Usuario',
                  flex:  3,
                  builder: (u) => _UserCell(usuario: u),
                ),
                AppTableColumn<UsuarioModel>(
                  label: 'Rol',
                  flex:  2,
                  builder: (u) => AppBadge(
                    label:   u.roles.firstOrNull?.replaceAll('_', ' ') ?? '—',
                    variant: AppBadgeVariant.primary,
                  ),
                ),
                AppTableColumn<UsuarioModel>(
                  label: 'Estado',
                  flex:  1,
                  builder: (u) => AppBadge(
                    label:   u.activo ? 'Activo' : 'Inactivo',
                    variant: u.activo ? AppBadgeVariant.success : AppBadgeVariant.neutral,
                    icon:    u.activo ? Icons.check_circle_outline : Icons.cancel_outlined,
                  ),
                ),
                AppTableColumn<UsuarioModel>(
                  label: 'Creado',
                  flex:  2,
                  builder: (u) => Text(
                    '${u.creadoEn.day}/${u.creadoEn.month}/${u.creadoEn.year}',
                    style: AppTypography.bodyMd,
                  ),
                ),
                AppTableColumn<UsuarioModel>(
                  label:     'Acciones',
                  flex:      1,
                  alignment: Alignment.center,
                  builder:   (u) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:      const Icon(Icons.edit_outlined, size: 18),
                        tooltip:   'Editar',
                        onPressed: () => _abrirFormulario(usuario: u),
                      ),
                      IconButton(
                        icon: Icon(
                          u.activo ? Icons.block_outlined : Icons.check_circle_outline,
                          size: 18,
                        ),
                        tooltip:   u.activo ? 'Desactivar' : 'Activar',
                        onPressed: () => _ctrl.toggleEstado(u),
                      ),
                      IconButton(
                        icon:      const Icon(Icons.delete_outline, size: 18),
                        color:     cs.error,
                        tooltip:   'Eliminar',
                        onPressed: () => _eliminar(u),
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

  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filtrar por estado', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              children: ['Activo', 'Inactivo'].map((e) => ChoiceChip(
                label:    Text(e),
                selected: _ctrl.filtroEstado == e,
                onSelected: (_) {
                  Navigator.pop(context);
                  _ctrl.filtrarEstado(e);
                },
              )).toList(),
            ),
            if (_ctrl.filtroEstado != null) ...[
              const SizedBox(height: AppSpacing.lg),
              TextButton.icon(
                onPressed: () { Navigator.pop(context); _ctrl.limpiarFiltros(); _searchCtrl.clear(); },
                icon:  const Icon(Icons.clear, size: 16),
                label: const Text('Limpiar filtros'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Widgets internos ──────────────────────────────────────────────────────────

class _UserCell extends StatelessWidget {
  const _UserCell({required this.usuario});
  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        CircleAvatar(
          radius:          18,
          backgroundColor: cs.primaryContainer,
          child: Text(
            usuario.nombre[0].toUpperCase(),
            style: TextStyle(
              fontSize:   13,
              fontWeight: FontWeight.bold,
              color:      cs.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(usuario.nombre, style: AppTypography.labelMd),
              Text(usuario.email,  style: AppTypography.caption),
            ],
          ),
        ),
      ],
    );
  }
}
