import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Acciones estándar de tabla — editar, toggle estado, eliminar.
/// Usar en TODAS las vistas con tabla para garantizar consistencia visual.
class AppTableActions extends StatelessWidget {
  const AppTableActions({
    super.key,
    this.onEdit,
    this.onToggle,
    this.isActive,
    this.onDelete,
    this.extra = const [],
  });

  final VoidCallback?        onEdit;
  final VoidCallback?        onToggle;
  final bool?                isActive;  // requerido si onToggle != null
  final VoidCallback?        onDelete;
  final List<Widget>         extra;     // acciones adicionales opcionales

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          _ActionIcon(
            icon:    Icons.edit_outlined,
            tooltip: 'Editar',
            color:   AppColors.accent,
            onTap:   onEdit!,
          ),
        if (onToggle != null)
          _ActionIcon(
            icon:    isActive == true
                ? Icons.block_outlined
                : Icons.check_circle_outline,
            tooltip: isActive == true ? 'Desactivar' : 'Activar',
            color:   isActive == true ? AppColors.warning : AppColors.success,
            onTap:   onToggle!,
          ),
        if (onDelete != null)
          _ActionIcon(
            icon:    Icons.delete_outline,
            tooltip: 'Eliminar',
            color:   AppColors.error,
            onTap:   onDelete!,
          ),
        ...extra,
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String   tooltip;
  final Color    color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
