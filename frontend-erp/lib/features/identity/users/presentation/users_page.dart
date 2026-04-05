import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_colors.dart';
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
    AppModal.show(
      context:     context,
      title:       usuario == null ? 'Nuevo usuario' : 'Editar usuario',
      subtitle:    usuario == null ? 'Completa los datos del nuevo usuario' : 'Modifica los datos',
      showActions: false,
      width:       520,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Toolbar: filtros + botón crear ───────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl2, AppSpacing.lg, AppSpacing.xl2, 0,
          ),
          child: Row(
            children: [
              AppFilterBar(
                  searchHint:       'Buscar por nombre o correo...',
                  searchController: _searchCtrl,
                  onSearchChanged:  _ctrl.buscar,
                  filterDefs: const [
                    AppFilterDef(
                      key:     'estado',
                      label:   'Estado',
                      type:    FilterType.select,
                      options: ['Activo', 'Inactivo'],
                    ),
                    AppFilterDef(
                      key:   'fecha',
                      label: 'Fecha de creación',
                      type:  FilterType.dateRange,
                    ),
                  ],
                  filterValues:     _ctrl.filtros,
                  onFiltersApplied: _ctrl.aplicarFiltros,
                  onFiltersClear:   _ctrl.limpiarFiltros,
              ),
              const SizedBox(width: AppSpacing.md),
              AppButton(
                label:     'Nuevo usuario',
                icon:      Icons.person_add_outlined,
                onPressed: () => _abrirFormulario(),
              ),
            ],
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
                  builder:   (u) => AppTableActions(
                    onEdit:   () => _abrirFormulario(usuario: u),
                    onToggle: () => _ctrl.toggleEstado(u),
                    isActive: u.activo,
                    onDelete: () => _eliminar(u),
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

  void _mostrarFiltros() {}
}

// ── Widgets internos ──────────────────────────────────────────────────────────

class _UserCell extends StatelessWidget {
  const _UserCell({required this.usuario});
  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius:          18,
          backgroundColor: AppColors.accent,
          child: Text(
            usuario.nombre[0].toUpperCase(),
            style: const TextStyle(
              fontSize:   13,
              fontWeight: FontWeight.bold,
              color:      AppColors.white,
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
              Text(usuario.email,  style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
            ],
          ),
        ),
      ],
    );
  }
}
