import 'package:flutter/material.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../permissions/data/permissions_repository.dart';
import '../../../permissions/domain/permission_model.dart';
import '../../domain/role_model.dart';

/// Modal de detalle de rol con tabs: Información | Permisos
class RoleDetailModal extends StatefulWidget {
  const RoleDetailModal({
    super.key,
    required this.rol,
    required this.onEditar,
  });

  final RolModel rol;
  final VoidCallback onEditar;

  static Future<void> show(
    BuildContext context, {
    required RolModel rol,
    required VoidCallback onEditar,
  }) {
    return AppSideSheet.show(
      context:     context,
      title:       rol.nombre.replaceAll('_', ' '),
      subtitle:    rol.descripcion,
      showActions: false,
      width:       520,
      child: RoleDetailModal(rol: rol, onEditar: onEditar),
    );
  }

  @override
  State<RoleDetailModal> createState() => _RoleDetailModalState();
}

class _RoleDetailModalState extends State<RoleDetailModal>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<PermissionModel> get _permisos => [];
  Map<String, List<PermissionModel>> get _permisosAgrupados => {};

  @override
  Widget build(BuildContext context) {
    final cs  = Theme.of(context).colorScheme;
    final rol = widget.rol;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl2, 0, AppSpacing.xl2, AppSpacing.lg,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color:        cs.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.shield_outlined, size: 24, color: cs.primary),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: AppBadge(
                  label:   '${rol.totalPermisos} permisos',
                  variant: AppBadgeVariant.info,
                  icon:    Icons.lock_outline,
                ),
              ),
              AppButton(
                label:    'Editar',
                icon:     Icons.edit_outlined,
                variant:  AppButtonVariant.secondary,
                size:     AppButtonSize.sm,
                onPressed: widget.onEditar,
              ),
            ],
          ),
        ),

        // ── Tabs ──────────────────────────────────────────────────────
        AppTabBar(
          controller: _tabCtrl,
          tabs: [
            const AppTabItem(label: 'Información', icon: Icons.info_outline),
            AppTabItem(
              label: 'Permisos',
              icon:  Icons.lock_outline,
              badge: rol.totalPermisos,
            ),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _TabInfo(rol: rol),
              _TabPermisos(grupos: _permisosAgrupados),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Tab: Información ──────────────────────────────────────────────────────────

class _TabInfo extends StatelessWidget {
  const _TabInfo({required this.rol});
  final RolModel rol;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Campo(label: 'Nombre',      value: rol.nombre.replaceAll('_', ' ')),
          _Campo(label: 'Descripción', value: rol.descripcion),
          _Campo(
            label: 'Creado el',
            value: '${rol.creadoEn.day}/${rol.creadoEn.month}/${rol.creadoEn.year}',
          ),
          _Campo(label: 'Total permisos', value: '${rol.totalPermisos}'),
        ],
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  const _Campo({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTypography.caption.copyWith(
                color: cs.onSurface.withOpacity(0.5),
              )),
          const SizedBox(height: 2),
          Text(value, style: AppTypography.bodyMd),
        ],
      ),
    );
  }
}

// ── Tab: Permisos agrupados ───────────────────────────────────────────────────

class _TabPermisos extends StatelessWidget {
  const _TabPermisos({required this.grupos});
  final Map<String, List<PermissionModel>> grupos;

  String _labelModulo(String m) => switch (m) {
    'identity'   => 'Identidad',
    'inventory'  => 'Inventario',
    'billing'    => 'Facturación',
    'purchasing' => 'Compras',
    'reports'    => 'Reportes',
    _            => m,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (grupos.isEmpty) {
      return const AppEmptyState(
        title:       'Sin permisos',
        description: 'Este rol no tiene permisos asignados',
        icon:        Icons.lock_open_outlined,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl2),
      children: grupos.entries.map((entry) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              _labelModulo(entry.key),
              style: AppTypography.labelMd.copyWith(color: cs.primary),
            ),
          ),
          ...entry.value.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline,
                    size: 14, color: cs.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(p.description, style: AppTypography.bodyMd),
                ),
              ],
            ),
          )),
          const SizedBox(height: AppSpacing.lg),
        ],
      )).toList(),
    );
  }
}
