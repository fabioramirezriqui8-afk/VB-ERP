import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../inputs/app_text_field.dart';

/// Barra de filtros reutilizable.
/// Incluye búsqueda + chips de filtros activos + botón de filtros avanzados.
class AppFilterBar extends StatelessWidget {
  const AppFilterBar({
    super.key,
    this.searchHint      = 'Buscar...',
    this.onSearchChanged,
    this.searchController,
    this.activeFilters   = const [],
    this.onRemoveFilter,
    this.onClearAll,
    this.onAdvancedFilter,
    this.actions         = const [],
  });

  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;
  final List<ActiveFilter> activeFilters;
  final void Function(ActiveFilter)? onRemoveFilter;
  final VoidCallback? onClearAll;
  final VoidCallback? onAdvancedFilter;
  final List<Widget> actions; // botones extra (ej: "Exportar", "Nuevo")

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Búsqueda
            Expanded(
              child: AppTextField(
                hint:          searchHint,
                controller:    searchController,
                onChanged:     onSearchChanged,
                prefixIcon:    Icons.search,
                suffixIcon:    searchController?.text.isNotEmpty == true
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          searchController?.clear();
                          onSearchChanged?.call('');
                        },
                      )
                    : null,
              ),
            ),
            if (onAdvancedFilter != null) ...[
              const SizedBox(width: AppSpacing.sm),
              _FilterButton(
                onTap:        onAdvancedFilter!,
                hasFilters:   activeFilters.isNotEmpty,
                filterCount:  activeFilters.length,
              ),
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.sm),
              ...actions.map((a) => Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: a,
              )),
            ],
          ],
        ),

        // Chips de filtros activos
        if (activeFilters.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...activeFilters.map((f) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: _ActiveFilterChip(
                    filter:   f,
                    onRemove: () => onRemoveFilter?.call(f),
                  ),
                )),
                if (activeFilters.length > 1)
                  TextButton.icon(
                    onPressed: onClearAll,
                    icon: const Icon(Icons.close, size: 14),
                    label: const Text('Limpiar todo'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      textStyle: AppTypography.labelSm,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Modelo de un filtro activo
class ActiveFilter {
  const ActiveFilter({
    required this.key,
    required this.label,
    required this.value,
  });

  final String key;
  final String label; // ej: "Estado"
  final String value; // ej: "Activo"
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.onTap,
    required this.hasFilters,
    required this.filterCount,
  });

  final VoidCallback onTap;
  final bool hasFilters;
  final int filterCount;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: hasFilters,
      label: Text('$filterCount'),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.tune, size: 16),
        label: const Text('Filtros'),
        style: OutlinedButton.styleFrom(
          foregroundColor: hasFilters ? AppColors.primary : AppColors.textSecondary,
          side: BorderSide(
            color: hasFilters ? AppColors.primary : AppColors.border,
          ),
        ),
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({required this.filter, required this.onRemove});

  final ActiveFilter filter;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        '${filter.label}: ${filter.value}',
        style: AppTypography.labelSm.copyWith(color: AppColors.primary),
      ),
      backgroundColor: AppColors.primary.withOpacity(0.08),
      side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
      deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.primary),
      onDeleted: onRemove,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
