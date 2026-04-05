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
  final int? badge;           // número en badge rojo (ej: notificaciones)
  final List<SidebarItem> children;
  final String? requiredPermission; // ocultar si el usuario no tiene el permiso

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
  final Widget? header;   // logo / nombre de empresa
  final Widget? footer;   // perfil de usuario
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
    // Expande automáticamente el grupo que contiene la ruta activa
    for (final item in widget.items) {
      if (item.hasChildren &&
          item.children.any((c) => c.route == widget.currentRoute)) {
        _expanded.add(item.id);
      }
    }
  }

  bool _hasAccess(SidebarItem item) {
    if (item.requiredPermission == null) return true;
    return widget.userPermissions.contains(item.requiredPermission);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = AppColors.sidebarBg;
    final w      = widget.isCollapsed ? widget.collapsedWidth : widget.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: w,
      color: bg,
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          _SidebarHeader(
            child:       widget.header,
            isCollapsed: widget.isCollapsed,
            onToggle:    widget.onToggleCollapse,
          ),

          const Divider(color: Colors.white12, height: 1),

          // ── Items ───────────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: widget.items
                  .where(_hasAccess)
                  .map((item) => item.hasChildren
                      ? _SidebarGroup(
                          item:        item,
                          isCollapsed: widget.isCollapsed,
                          isExpanded:  _expanded.contains(item.id),
                          currentRoute: widget.currentRoute,
                          onToggle: () => setState(() {
                            _expanded.contains(item.id)
                                ? _expanded.remove(item.id)
                                : _expanded.add(item.id);
                          }),
                          onNavigate:  widget.onNavigate,
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

          // ── Footer ──────────────────────────────────────────────────────────
          if (widget.footer != null) ...[
            const Divider(color: Colors.white12, height: 1),
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
                  : child ??
                      Text(
                        'VB-ERP',
                        style: AppTypography.h3.copyWith(color: AppColors.white),
                      ),
            ),
          ),
          IconButton(
            icon: Icon(
              isCollapsed ? Icons.menu_open : Icons.menu,
              color: Colors.white70,
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
    final activeColor = AppColors.primary;
    final textColor   = isActive ? activeColor : AppColors.textSecondary;
    final bgColor     = isActive
        ? AppColors.sidebarActive
        : Colors.transparent;

    return Tooltip(
      message: isCollapsed ? item.label : '',
      preferBelow: false,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical:   2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isChild ? AppSpacing.xl2 : AppSpacing.md,
            vertical:   AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color:        bgColor,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border(left: BorderSide(color: activeColor, width: 2))
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
    final hasActiveChild =
        item.children.any((c) => c.route == currentRoute);
    final textColor = hasActiveChild ? AppColors.primary : AppColors.textSecondary;

    return Column(
      children: [
        // Cabecera del grupo
        Tooltip(
          message: isCollapsed ? item.label : '',
          preferBelow: false,
          child: InkWell(
            onTap: isCollapsed ? null : onToggle,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: 2,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: hasActiveChild
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
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
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: AppColors.textDisabled,
                      size: 18,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Hijos
        if (!isCollapsed)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: item.children
                        .where(_hasAccess)
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
          color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600,
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
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
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
                    Text(
                      name,
                      style: AppTypography.labelMd.copyWith(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      role,
                      style: AppTypography.caption.copyWith(
                        color: Colors.white54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white38, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
