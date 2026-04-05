import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'app_sidebar.dart';

/// Shell principal del ERP.
/// Envuelve todas las pantallas con sidebar + topbar.
/// En móvil el sidebar se convierte en Drawer.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.child,
    required this.currentRoute,
    required this.onNavigate,
    required this.sidebarItems,
    this.title,
    this.actions        = const [],
    this.userName       = '',
    this.userRole       = '',
    this.userAvatarUrl,
    this.userPermissions = const [],
    this.onUserTap,
    this.onNotificationTap,
    this.notificationCount = 0,
  });

  final Widget child;
  final String currentRoute;
  final void Function(String route) onNavigate;
  final List<SidebarItem> sidebarItems;
  final String? title;
  final List<Widget> actions;
  final String userName;
  final String userRole;
  final String? userAvatarUrl;
  final List<String> userPermissions;
  final VoidCallback? onUserTap;
  final VoidCallback? onNotificationTap;
  final int notificationCount;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isCollapsed = false;
  static const double _mobileBreakpoint = 768;

  bool get _isMobile =>
      MediaQuery.of(context).size.width < _mobileBreakpoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // En móvil el sidebar es un Drawer
      drawer: _isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          // Sidebar (solo desktop/tablet)
          if (!_isMobile)
            AppSidebar(
              items:           widget.sidebarItems,
              currentRoute:    widget.currentRoute,
              onNavigate:      widget.onNavigate,
              userPermissions: widget.userPermissions,
              isCollapsed:     _isCollapsed,
              onToggleCollapse: () =>
                  setState(() => _isCollapsed = !_isCollapsed),
              footer: SidebarUserFooter(
                name:        widget.userName,
                role:        widget.userRole,
                avatarUrl:   widget.userAvatarUrl,
                isCollapsed: _isCollapsed,
                onTap:       widget.onUserTap,
              ),
            ),

          // Contenido principal
          Expanded(
            child: Column(
              children: [
                _AppTopBar(
                  title:             widget.title,
                  actions:           widget.actions,
                  isMobile:          _isMobile,
                  notificationCount: widget.notificationCount,
                  onNotificationTap: widget.onNotificationTap,
                  onMenuTap: _isMobile
                      ? () => Scaffold.of(context).openDrawer()
                      : null,
                ),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: AppSidebar(
        items:           widget.sidebarItems,
        currentRoute:    widget.currentRoute,
        onNavigate: (route) {
          Navigator.of(context).pop(); // cierra el drawer
          widget.onNavigate(route);
        },
        userPermissions: widget.userPermissions,
        footer: SidebarUserFooter(
          name:      widget.userName,
          role:      widget.userRole,
          avatarUrl: widget.userAvatarUrl,
          onTap:     widget.onUserTap,
        ),
      ),
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────

class _AppTopBar extends StatelessWidget {
  const _AppTopBar({
    this.title,
    this.actions        = const [],
    required this.isMobile,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onMenuTap,
  });

  final String? title;
  final List<Widget> actions;
  final bool isMobile;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Botón hamburguesa en móvil
          if (onMenuTap != null) ...[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],

          // Título de la página actual
          if (title != null)
            Expanded(
              child: Text(title!, style: AppTypography.h4),
            )
          else
            const Spacer(),

          // Acciones custom
          ...actions,

          // Notificaciones
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: onNotificationTap,
                tooltip: 'Notificaciones',
              ),
              if (notificationCount > 0)
                Positioned(
                  top: 6, right: 6,
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
