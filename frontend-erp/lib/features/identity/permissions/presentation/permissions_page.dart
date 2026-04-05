import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../data/permissions_repository.dart';
import '../domain/permission_model.dart';

class PermisosPage extends StatefulWidget {
  const PermisosPage({super.key});

  @override
  State<PermisosPage> createState() => _PermisosPageState();
}

class _PermisosPageState extends State<PermisosPage> {
  final _repo      = PermissionsRepository();
  List<PermissionModel> _todos    = [];
  bool    _isLoading = true;
  String? _error;
  String  _busqueda  = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final perms = await _repo.listPermissions();
      if (mounted) setState(() { _todos = perms; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  List<PermissionModel> get _filtrados => _todos.where((p) =>
    p.name.toLowerCase().contains(_busqueda.toLowerCase()) ||
    p.description.toLowerCase().contains(_busqueda.toLowerCase()),
  ).toList();

  Map<String, List<PermissionModel>> get _grupos {
    final mapa = <String, List<PermissionModel>>{};
    for (final p in _filtrados) {
      mapa.putIfAbsent(p.module, () => []).add(p);
    }
    return mapa;
  }

  String _labelModulo(String m) => switch (m) {
    'identity'   => '🔐  Identidad',
    'inventory'  => '📦  Inventario',
    'billing'    => '🧾  Facturación',
    'purchasing' => '🛒  Compras',
    'crm'        => '🤝  CRM',
    'finance'    => '💰  Finanzas',
    'hr'         => '👥  RRHH',
    'reports'    => '📊  Reportes',
    _            => m,
  };

  String _labelAccion(String a) => switch (a) {
    'read'    => 'Lectura',  'create'   => 'Crear',
    'update'  => 'Editar',   'delete'   => 'Eliminar',
    'manage'  => 'Gestionar','approve'  => 'Aprobar',
    'adjust'  => 'Ajustar',  'export'   => 'Exportar',
    _         => a,
  };

  AppBadgeVariant _variantAccion(String a) => switch (a) {
    'read'   => AppBadgeVariant.info,
    'create' => AppBadgeVariant.success,
    'update' => AppBadgeVariant.warning,
    'delete' => AppBadgeVariant.error,
    _        => AppBadgeVariant.neutral,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_isLoading) return const Center(child: AppLoadingIndicator(size: 36));
    if (_error != null) return AppErrorState(message: _error!, onRetry: _load);

    final grupos = _grupos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl2, AppSpacing.xl2, AppSpacing.xl2, AppSpacing.lg),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(bottom: BorderSide(color: cs.outline.withOpacity(0.12))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBreadcrumb(items: const [
                BreadcrumbItem(label: 'Inicio', route: '/dashboard'),
                BreadcrumbItem(label: 'Permisos'),
              ]),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Permisos del sistema', style: AppTypography.h2),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${_todos.length} permisos en ${_grupos.length} módulos',
                            style: AppTypography.bodyMd.copyWith(color: cs.onSurface.withOpacity(0.5))),
                      ],
                    ),
                  ),
                  AppBadge(label: 'Solo lectura', variant: AppBadgeVariant.neutral, icon: Icons.lock_outline),
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl2, AppSpacing.xl2, AppSpacing.xl2, 0),
          child: AppFilterBar(
            searchHint:      'Buscar permiso...',
            onSearchChanged: (q) => setState(() => _busqueda = q),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        Expanded(
          child: grupos.isEmpty
              ? AppEmptyState(title: 'Sin resultados', icon: Icons.search_off_outlined)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl2, 0, AppSpacing.xl2, AppSpacing.xl2),
                  itemCount: grupos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
                  itemBuilder: (_, i) {
                    final entry = grupos.entries.elementAt(i);
                    return AppCard(
                      title:    _labelModulo(entry.key),
                      trailing: AppBadge(label: '${entry.value.length}', variant: AppBadgeVariant.primary),
                      child: Column(
                        children: entry.value.asMap().entries.map((e) {
                          final p      = e.value;
                          final isLast = e.key == entry.value.length - 1;
                          return Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                              child: Row(children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.description, style: AppTypography.labelMd),
                                    const SizedBox(height: 2),
                                    Text(p.name, style: AppTypography.caption.copyWith(
                                      fontFamily: 'monospace',
                                      color: cs.primary.withOpacity(0.8),
                                    )),
                                  ],
                                )),
                                const SizedBox(width: AppSpacing.lg),
                                AppBadge(label: _labelAccion(p.action), variant: _variantAccion(p.action)),
                              ]),
                            ),
                            if (!isLast) Divider(height: 1, color: cs.outline.withOpacity(0.08)),
                          ]);
                        }).toList(),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
