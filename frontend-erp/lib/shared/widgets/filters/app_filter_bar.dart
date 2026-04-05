import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../inputs/app_text_field.dart';
import 'app_filter_def.dart';
import 'app_filter_panel.dart';

// Re-exports para que quien importe app_filter_bar tenga todo
export 'app_filter_def.dart';
export 'app_filter_panel.dart';

/// Modelo legacy — mantenido para compatibilidad
class FilterOption {
  const FilterOption({required this.key, required this.label, required this.value});
  final String key;
  final String label;
  final String value;
}

/// Modelo de un filtro activo (legacy)
class ActiveFilter {
  const ActiveFilter({required this.key, required this.label, required this.value});
  final String key;
  final String label;
  final String value;
}

/// Barra de filtros reutilizable.
/// Búsqueda + dropdown de opciones inline + chips de filtros activos.
/// Soporta el nuevo sistema AppFilterDef (select, dateRange, numberRange)
/// y el sistema legacy de FilterOption.
class AppFilterBar extends StatelessWidget {
  const AppFilterBar({
    super.key,
    this.searchHint        = 'Buscar...',
    this.onSearchChanged,
    this.searchController,
    // ── Nuevo sistema ──────────────────────────────────────────────────
    this.filterDefs        = const [],
    this.filterValues      = const [],
    this.onFiltersApplied,
    this.onFiltersClear,
    // ── Legacy ─────────────────────────────────────────────────────────
    this.activeFilters     = const [],
    this.onRemoveFilter,
    this.onClearAll,
    this.filterOptions     = const [],
    this.onFilterSelected,
    this.onAdvancedFilter,
    this.actions           = const [],
  });

  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;

  // Nuevo sistema
  final List<AppFilterDef>   filterDefs;
  final List<AppFilterValue> filterValues;
  final void Function(List<AppFilterValue>)? onFiltersApplied;
  final VoidCallback? onFiltersClear;

  // Legacy
  final List<ActiveFilter> activeFilters;
  final void Function(ActiveFilter)? onRemoveFilter;
  final VoidCallback? onClearAll;
  final List<FilterOption> filterOptions;
  final void Function(FilterOption)? onFilterSelected;
  final VoidCallback? onAdvancedFilter;
  final List<Widget> actions;

  bool get _useNewSystem => filterDefs.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final hasFilterBtn = _useNewSystem ||
        filterOptions.isNotEmpty ||
        onAdvancedFilter != null;

    // Chips activos unificados
    final chips = _useNewSystem
        ? filterValues.map((v) => _ChipData(
              label:    '${v.label}: ${v.displayValue}',
              onRemove: () {
                final updated = filterValues.where((x) => x != v).toList();
                onFiltersApplied?.call(updated);
              },
            )).toList()
        : activeFilters.map((f) => _ChipData(
              label:    '${f.label}: ${f.value}',
              onRemove: () => onRemoveFilter?.call(f),
            )).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Búsqueda con ancho fijo máximo
            SizedBox(
              width: 280,
              child: AppTextField(
                hint:       searchHint,
                controller: searchController,
                onChanged:  onSearchChanged,
                prefixIcon: Icons.search,
                suffixIcon: searchController?.text.isNotEmpty == true
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

            if (hasFilterBtn) ...[
              const SizedBox(width: AppSpacing.sm),
              if (_useNewSystem)
                _NewFilterButton(
                  filterDefs:   filterDefs,
                  filterValues: filterValues,
                  onApply:      onFiltersApplied ?? (_) {},
                  onClear:      onFiltersClear ?? () {},
                )
              else if (filterOptions.isNotEmpty)
                _DropdownFilterButton(
                  options:       filterOptions,
                  activeFilters: activeFilters,
                  onSelected:    onFilterSelected,
                )
              else
                _LegacyFilterButton(
                  onTap:       onAdvancedFilter!,
                  hasFilters:  activeFilters.isNotEmpty,
                  filterCount: activeFilters.length,
                ),
            ],

            ...actions.map((a) => Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: a,
            )),
          ],
        ),

        if (chips.isNotEmpty && false) ...[  // chips deshabilitados
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...chips.map((c) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Chip(
                    label: Text(c.label,
                        style: AppTypography.labelSm.copyWith(color: AppColors.accent)),
                    backgroundColor: AppColors.accentLight,
                    side: BorderSide(color: AppColors.accent.withOpacity(0.3)),
                    deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.accent),
                    onDeleted: c.onRemove,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                )),
                if (chips.length > 1)
                  TextButton.icon(
                    onPressed: _useNewSystem ? onFiltersClear : onClearAll,
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

// ── Helper interno ────────────────────────────────────────────────────────────

class _ChipData {
  const _ChipData({required this.label, required this.onRemove});
  final String label;
  final VoidCallback onRemove;
}

// ── Botón nuevo sistema ───────────────────────────────────────────────────────

class _NewFilterButton extends StatelessWidget {
  const _NewFilterButton({
    required this.filterDefs,
    required this.filterValues,
    required this.onApply,
    required this.onClear,
  });

  final List<AppFilterDef>   filterDefs;
  final List<AppFilterValue> filterValues;
  final void Function(List<AppFilterValue>) onApply;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasActive = filterValues.isNotEmpty;
    return GestureDetector(
      onTap: () => AppFilterPanel.show(
        context:      context,
        filters:      filterDefs,
        activeValues: filterValues,
        onApply:      onApply,
        onClear:      onClear,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color:        hasActive ? AppColors.accentLight : AppColors.surface,
          border:       Border.all(
              color: hasActive ? AppColors.accent : AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune, size: 16,
                color: hasActive ? AppColors.accent : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text('Filtros',
                style: AppTypography.labelMd.copyWith(
                  color: hasActive ? AppColors.accent : AppColors.textSecondary,
                )),
            if (hasActive) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('${filterValues.length}',
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Dropdown inline de filtros (legacy) ───────────────────────────────────────

class _DropdownFilterButton extends StatelessWidget {
  const _DropdownFilterButton({
    required this.options,
    required this.activeFilters,
    required this.onSelected,
  });

  final List<FilterOption> options;
  final List<ActiveFilter> activeFilters;
  final void Function(FilterOption)? onSelected;

  bool _isActive(FilterOption opt) =>
      activeFilters.any((f) => f.key == opt.key && f.value == opt.value);

  @override
  Widget build(BuildContext context) {
    final hasActive = activeFilters.isNotEmpty;

    return PopupMenuButton<FilterOption>(
      tooltip:   'Filtros',
      color:     AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
      offset: const Offset(0, 40),
      itemBuilder: (_) => options.map((opt) {
        final active = _isActive(opt);
        return PopupMenuItem<FilterOption>(
          value: opt,
          child: Row(
            children: [
              Icon(
                active ? Icons.check_box : Icons.check_box_outline_blank,
                size: 18,
                color: active ? AppColors.accent : AppColors.textMuted,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${opt.label}: ${opt.value}',
                style: AppTypography.bodyMd.copyWith(
                  color: active ? AppColors.accent : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onSelected: (opt) => onSelected?.call(opt),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color:        hasActive ? AppColors.accentLight : AppColors.surface,
          border: Border.all(
            color: hasActive ? AppColors.accent : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune, size: 16,
                color: hasActive ? AppColors.accent : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text('Filtros',
                style: AppTypography.labelMd.copyWith(
                  color: hasActive ? AppColors.accent : AppColors.textSecondary,
                )),
            if (hasActive) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('${activeFilters.length}',
                    style: const TextStyle(
                        color: AppColors.white, fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Legacy (cuando no hay filterOptions) ─────────────────────────────────────

class _LegacyFilterButton extends StatelessWidget {
  const _LegacyFilterButton({
    required this.onTap,
    required this.hasFilters,
    required this.filterCount,
  });

  final VoidCallback onTap;
  final bool hasFilters;
  final int filterCount;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.tune, size: 16),
      label: const Text('Filtros'),
      style: OutlinedButton.styleFrom(
        foregroundColor: hasFilters ? AppColors.accent : AppColors.textSecondary,
        side: BorderSide(color: hasFilters ? AppColors.accent : AppColors.border),
      ),
    );
  }
}

// ── Chip de filtro activo ─────────────────────────────────────────────────────

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({required this.filter, required this.onRemove});

  final ActiveFilter filter;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        '${filter.label}: ${filter.value}',
        style: AppTypography.labelSm.copyWith(color: AppColors.accent),
      ),
      backgroundColor: AppColors.accentLight,
      side: BorderSide(color: AppColors.accent.withOpacity(0.3)),
      deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.accent),
      onDeleted: onRemove,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
