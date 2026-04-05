import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// ── Modelos ───────────────────────────────────────────────────────────────────

class SidebarItem {
  const SidebarItem({
    required this.id,
    required this.label,
    required this.icon,
    this.route,
    this.badge,
    this.children = const [],
    this.requiredPermission,
  });

  final String id;
  final String label;
  final IconData icon;
  final String? route;
  final int? badge;
  final List<SidebarItem> children;
  final String? requiredPermission;

  bool get hasChildren => children.isNotEmpty;
}

// ── Widget principal ──────────────────────────────────────────────────────────

class AppSidebar extends StatefulWidget {
  const AppSidebar({
    super.key,
    required this.items,
    required this.currentRoute,
    required this.onNavigate,
    this.header,
    this.footer,
    this.userPermissions = const [],
    this.width           = 260.0,
    this.collapsedWidth  = 64.0,
    this.isCollapsed     = false,
    this.onToggleCollapse,
  });

  final List<SidebarItem> items;
  final String currentRoute;
  final void Function(String route) onNavigate;
  final Widget? header;
  final Widget? footer;
  final List<String> userPermissions;
  final double width;
  final double collapsedWidth;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    for (final item in widget.items) {
      if (item.hasChildren &&
          item.children.any((c) => c.route == widget.currentRoute)) {
        _expanded.add(item.id);
      }
    }
  }

  bool _hasAccess(SidebarItem item) {
    if (item.hasChildren) return item.children.any(_hasAccess);
    if (item.requiredPermission == null) return true;
    return widget.userPermissions.contains(item.requiredPermission);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.isCollapsed ? widget.collapsedWidth : widget.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: w,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          _SidebarHeader(
            child:       widget.header,
            isCollapsed: widget.isCollapsed,
            onToggle:    widget.onToggleCollapse,
          ),
          const Divider(color: Color(0xFF1E293B), height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: widget.items
                  .where(_hasAccess)
                  .map((item) => item.hasChildren
                      ? _SidebarGroup(
                          item:            item,
                          isCollapsed:     widget.isCollapsed,
                          isExpanded:      _expanded.contains(item.id),
                          currentRoute:    widget.currentRoute,
                          onToggle: () => setState(() {
                            _expanded.contains(item.id)
                                ? _expanded.remove(item.id)
                                : _expanded.add(item.id);
                          }),
                          onNavigate:      widget.onNavigate,
                          userPermissions: widget.userPermissions,
                        )
                      : _SidebarTile(
                          item:        item,
                          isCollapsed: widget.isCollapsed,
                          isActive:    widget.currentRoute == item.route,
                          onTap: () => item.route != null
                              ? widget.onNavigate(item.route!)
                              : null,
                        ))
                  .toList(),
            ),
          ),
          if (widget.footer != null) ...[
            const Divider(color: Color(0xFF1E293B), height: 1),
            widget.footer!,
          ],
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({this.child, required this.isCollapsed, this.onToggle});
  final Widget? child;
  final bool isCollapsed;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: isCollapsed
                  ? const SizedBox.shrink()
                  : child ?? Text(
                      'VB-ERP',
                      style: AppTypography.h3.copyWith(color: AppColors.accent),
                    ),
            ),
          ),
          IconButton(
            icon: Icon(
              isCollapsed ? Icons.menu_open : Icons.menu,
              color: AppColors.sidebarText,
            ),
            onPressed: onToggle,
            tooltip: isCollapsed ? 'Expandir' : 'Colapsar',
          ),
        ],
      ),
    );
  }
}

// ── Tile individual ───────────────────────────────────────────────────────────

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.item,
    required this.isCollapsed,
    required this.isActive,
    required this.onTap,
    this.isChild = false,
  });

  final SidebarItem item;
  final bool isCollapsed;
  final bool isActive;
  final VoidCallback onTap;
  final bool isChild;

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? AppColors.accent : AppColors.sidebarText;
    final bgColor   = isActive ? AppColors.sidebarActive : Colors.transparent;

    return Tooltip(
      message: isCollapsed ? item.label : '',
      preferBelow: false,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.sidebarActive,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
          padding: EdgeInsets.symmetric(
            horizontal: isChild ? AppSpacing.xl2 : AppSpacing.md,
            vertical:   AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color:        bgColor,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? const Border(left: BorderSide(color: AppColors.accent, width: 2))
                : null,
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(item.icon, color: textColor, size: 20),
                  if (item.badge != null && item.badge! > 0)
                    Positioned(
                      top: -4, right: -6,
                      child: _Badge(count: item.badge!),
                    ),
                ],
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTypography.labelMd.copyWith(color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.badge != null && item.badge! > 0)
                  _Badge(count: item.badge!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Grupo colapsable ──────────────────────────────────────────────────────────

class _SidebarGroup extends StatelessWidget {
  const _SidebarGroup({
    required this.item,
    required this.isCollapsed,
    required this.isExpanded,
    required this.currentRoute,
    required this.onToggle,
    required this.onNavigate,
    required this.userPermissions,
  });

  final SidebarItem item;
  final bool isCollapsed;
  final bool isExpanded;
  final String currentRoute;
  final VoidCallback onToggle;
  final void Function(String) onNavigate;
  final List<String> userPermissions;

  bool _hasAccess(SidebarItem child) {
    if (child.requiredPermission == null) return true;
    return userPermissions.contains(child.requiredPermission);
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveChild = item.children.any((c) => c.route == currentRoute);
    final filteredChildren = item.children.where(_hasAccess).toList();
    if (filteredChildren.isEmpty) return const SizedBox.shrink();

    final textColor = hasActiveChild ? AppColors.accent : AppColors.sidebarText;

    return Column(
      children: [
        Tooltip(
          message: isCollapsed ? item.label : '',
          preferBelow: false,
          child: InkWell(
            onTap: isCollapsed ? null : onToggle,
            hoverColor: AppColors.sidebarActive,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: hasActiveChild ? AppColors.sidebarActive : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: textColor, size: 20),
                  if (!isCollapsed) ...[
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        item.label,
                        style: AppTypography.labelMd.copyWith(color: textColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                      color: AppColors.sidebarText,
                      size: 18,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (!isCollapsed)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: filteredChildren
                        .map((child) => _SidebarTile(
                              item:        child,
                              isCollapsed: false,
                              isActive:    currentRoute == child.route,
                              isChild:     true,
                              onTap: () => child.route != null
                                  ? onNavigate(child.route!)
                                  : null,
                            ))
                        .toList(),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }
}

// ── Badge numérico ────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color:        AppColors.error,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: AppColors.white, fontSize: 10, fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Footer de usuario ─────────────────────────────────────────────────────────

class SidebarUserFooter extends StatelessWidget {
  const SidebarUserFooter({
    super.key,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.onTap,
    this.isCollapsed = false,
  });

  final String name;
  final String role;
  final String? avatarUrl;
  final VoidCallback? onTap;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: AppColors.sidebarActive,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.accent,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis),
                    Text(_mapRole(role),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.sidebarText,
                        ),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.unfold_more_rounded, color: AppColors.sidebarText, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  String _mapRole(String roleId) {
    return switch (roleId.toLowerCase()) {
      'super_admin'        => 'Administrador',
      'sales_agent'        => 'Agente de Ventas',
      'warehouse_operator' => 'Operador Almacén',
      'admin'              => 'Administrador',
      _                    => roleId.replaceAll('_', ' ').toUpperCase(),
    };
  }
}
