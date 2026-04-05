import 'package:flutter/material.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../permissions/data/permissions_repository.dart';
import '../../../permissions/domain/permission_model.dart';
import '../../domain/user_model.dart';

/// Modal de detalle de usuario con tabs: Información | Permisos | Actividad
class UserDetailModal extends StatefulWidget {
  const UserDetailModal({
    super.key,
    required this.usuario,
    required this.onEditar,
  });

  final UsuarioModel usuario;
  final VoidCallback onEditar;

  static Future<void> show(
    BuildContext context, {
    required UsuarioModel usuario,
    required VoidCallback onEditar,
  }) {
    return AppSideSheet.show(
      context:     context,
      title:       usuario.nombre,
      subtitle:    usuario.email,
      showActions: false,
      width:       520,
      child: UserDetailModal(usuario: usuario, onEditar: onEditar),
    );
  }

  @override
  State<UserDetailModal> createState() => _UserDetailModalState();
}

class _UserDetailModalState extends State<UserDetailModal>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<PermissionModel> get _permisosDelRol => [];

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final usuario = widget.usuario;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Avatar + estado ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl2, 0, AppSpacing.xl2, AppSpacing.lg,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: cs.primaryContainer,
                child: Text(
                  usuario.nombre[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBadge(
                      label:   usuario.activo ? 'Activo' : 'Inactivo',
                      variant: usuario.activo
                          ? AppBadgeVariant.success
                          : AppBadgeVariant.neutral,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppBadge(
                      label:   usuario.roles.firstOrNull?.replaceAll('_', ' ') ?? '—',
                      variant: AppBadgeVariant.primary,
                    ),
                  ],
                ),
              ),
              AppButton(
                label:   'Editar',
                icon:    Icons.edit_outlined,
                variant: AppButtonVariant.secondary,
                size:    AppButtonSize.sm,
                onPressed: widget.onEditar,
              ),
            ],
          ),
        ),

        // ── Tabs ──────────────────────────────────────────────────────
        AppTabBar(
          controller: _tabCtrl,
          tabs: const [
            AppTabItem(label: 'Información', icon: Icons.person_outline),
            AppTabItem(label: 'Permisos',    icon: Icons.lock_outline),
            AppTabItem(label: 'Actividad',   icon: Icons.history_outlined),
          ],
        ),

        // ── Contenido de tabs ─────────────────────────────────────────
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _TabInformacion(usuario: usuario),
              _TabPermisos(permisos: _permisosDelRol),
              _TabActividad(usuario: usuario),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Tab: Información ──────────────────────────────────────────────────────────

class _TabInformacion extends StatelessWidget {
  const _TabInformacion({required this.usuario});
  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl2),
      child: Column(
        children: [
          _InfoRow(label: 'Nombre',   value: usuario.nombre,  icon: Icons.person_outline),
          _InfoRow(label: 'Correo',   value: usuario.email,   icon: Icons.email_outlined),
          _InfoRow(
            label: 'Rol',
            value: usuario.roles.firstOrNull?.replaceAll('_', ' ') ?? '—',
            icon:  Icons.shield_outlined,
          ),
          _InfoRow(
            label: 'Estado',
            value: usuario.activo ? 'Activo' : 'Inactivo',
            icon:  Icons.circle,
            valueColor: usuario.activo ? cs.primary : cs.onSurface.withOpacity(0.4),
          ),
          _InfoRow(
            label: 'Creado el',
            value: '${usuario.creadoEn.day}/${usuario.creadoEn.month}/${usuario.creadoEn.year}',
            icon:  Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.onSurface.withOpacity(0.4)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTypography.caption.copyWith(
                      color: cs.onSurface.withOpacity(0.5),
                    )),
                Text(value,
                    style: AppTypography.bodyMd.copyWith(
                      color: valueColor ?? cs.onSurface,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab: Permisos ─────────────────────────────────────────────────────────────

class _TabPermisos extends StatelessWidget {
  const _TabPermisos({required this.permisos});
  final List<PermissionModel> permisos;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Permisos heredados del rol asignado',
            style: AppTypography.bodySm.copyWith(color: cs.onSurface.withOpacity(0.5)),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...permisos.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, size: 16, color: cs.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(p.description, style: AppTypography.bodyMd)),
                AppBadge(label: p.module, variant: AppBadgeVariant.neutral),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ── Tab: Actividad ────────────────────────────────────────────────────────────

class _TabActividad extends StatelessWidget {
  const _TabActividad({required this.usuario});
  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl2),
      child: AppTimeline(events: [
        TimelineEvent(
          title:     'Usuario creado',
          date:      '${usuario.creadoEn.day}/${usuario.creadoEn.month}/${usuario.creadoEn.year}',
          actor:     'Por: Administrador',
          icon:      Icons.person_add_outlined,
          iconColor: Colors.green,
        ),
        const TimelineEvent(
          title:     'Rol asignado',
          date:      'Hace 2 días',
          actor:     'Por: Administrador',
          icon:      Icons.shield_outlined,
          iconColor: Colors.blue,
        ),
        const TimelineEvent(
          title:     'Último acceso',
          date:      'Hace 1 hora',
          icon:      Icons.login_outlined,
          iconColor: Colors.purple,
        ),
      ]),
    );
  }
}
