import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../feedback/app_loading_indicator.dart';
import '../layout/app_empty_state.dart';

/// Definición de una columna de la tabla
class AppTableColumn<T> {
  const AppTableColumn({
    required this.label,
    required this.builder,
    this.width,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
  });

  final String label;
  final Widget Function(T row) builder;
  final double? width;   // ancho fijo (opcional)
  final int flex;        // peso relativo si no hay ancho fijo
  final Alignment alignment;
}

/// Tabla genérica reutilizable para cualquier módulo del ERP.
/// Soporta: scroll horizontal, paginación, selección, loading, vacío.
class AppTable<T> extends StatefulWidget {
  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading    = false,
    this.onRowTap,
    this.selectedRows = const {},
    this.onSelectRow,
    this.onSelectAll,
    this.showCheckbox = false,
    this.emptyTitle   = 'Sin resultados',
    this.emptyDescription,
    this.emptyIcon    = Icons.table_rows_outlined,
    this.totalItems   = 0,
    this.currentPage  = 1,
    this.pageSize     = 20,
    this.onPageChanged,
    this.showPagination = true,
  });

  final List<AppTableColumn<T>> columns;
  final List<T> rows;
  final bool isLoading;
  final void Function(T row)? onRowTap;
  final Set<T> selectedRows;
  final void Function(T row, bool selected)? onSelectRow;
  final void Function(bool selectAll)? onSelectAll;
  final bool showCheckbox;
  final String emptyTitle;
  final String? emptyDescription;
  final IconData emptyIcon;
  final int totalItems;
  final int currentPage;
  final int pageSize;
  final void Function(int page)? onPageChanged;
  final bool showPagination;

  @override
  State<AppTable<T>> createState() => _AppTableState<T>();
}

class _AppTableState<T> extends State<AppTable<T>> {
  final ScrollController _vScroll = ScrollController();
  final ScrollController _hScroll = ScrollController();

  @override
  void dispose() {
    _vScroll.dispose();
    _hScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildTable(context)),
        if (widget.showPagination && widget.totalItems > 0)
          _AppTablePagination(
            totalItems:    widget.totalItems,
            currentPage:   widget.currentPage,
            pageSize:      widget.pageSize,
            onPageChanged: widget.onPageChanged,
          ),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: AppLoadingIndicator(size: 36));
    }

    if (widget.rows.isEmpty) {
      return AppEmptyState(
        title:       widget.emptyTitle,
        description: widget.emptyDescription,
        icon:        widget.emptyIcon,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Enforce a minimum width of 1000px to ensure 'Expanded' cells have finite space.
        final double tableWidth = constraints.maxWidth > 1000 ? constraints.maxWidth : 1000;

        return Scrollbar(
          controller: _vScroll,
          thumbVisibility: true,
          child: Scrollbar(
            controller: _hScroll,
            thumbVisibility: true,
            notificationPredicate: (n) => n.depth == 1,
            child: SingleChildScrollView(
              controller: _vScroll,
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                controller: _hScroll,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context),
                      const Divider(height: 1),
                      ...List.generate(widget.rows.length, (i) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildRow(context, widget.rows[i], i),
                            const Divider(height: 1),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.surfaceHover : AppColors.surfaceVariantLight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical:   AppSpacing.md,
      ),
      child: Row(
        children: [
          if (widget.showCheckbox)
            Checkbox(
              value: widget.rows.isNotEmpty && widget.selectedRows.length == widget.rows.length,
              tristate: true,
              onChanged: (v) => widget.onSelectAll?.call(v ?? false),
            ),
          ...widget.columns.map((col) => _cellWrapper(
            col,
            Text(col.label, style: AppTypography.labelMd),
          )),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, T row, int index) {
    final isSelected = widget.selectedRows.contains(row);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: widget.onRowTap != null ? () => widget.onRowTap!(row) : null,
      child: Container(
        color: isSelected
            ? AppColors.primary.withOpacity(0.06)
            : index.isOdd
                ? (isDark ? AppColors.surfaceHover.withOpacity(0.5) : AppColors.surfaceVariantLight.withOpacity(0.5))
                : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.md,
        ),
        child: Row(
          children: [
            if (widget.showCheckbox)
              Checkbox(
                value: isSelected,
                onChanged: (v) => widget.onSelectRow?.call(row, v ?? false),
              ),
            ...widget.columns.map((col) => _cellWrapper(col, col.builder(row))),
          ],
        ),
      ),
    );
  }

  Widget _cellWrapper(AppTableColumn<T> col, Widget child) {
    if (col.width != null) {
      return SizedBox(
        width: col.width,
        child: Align(alignment: col.alignment, child: child),
      );
    }
    return Expanded(
      flex: col.flex,
      child: Align(alignment: col.alignment, child: child),
    );
  }
}

// ── Paginación ────────────────────────────────────────────────────────────────

class _AppTablePagination extends StatelessWidget {
  const _AppTablePagination({
    required this.totalItems,
    required this.currentPage,
    required this.pageSize,
    this.onPageChanged,
  });

  final int totalItems;
  final int currentPage;
  final int pageSize;
  final void Function(int page)? onPageChanged;

  int get _totalPages => (totalItems / pageSize).ceil();
  int get _from => ((currentPage - 1) * pageSize) + 1;
  int get _to   => (currentPage * pageSize).clamp(0, totalItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical:   AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Mostrando $_from–$_to de $totalItems',
            style: AppTypography.bodySm,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: currentPage > 1 ? () => onPageChanged?.call(1) : null,
            tooltip: 'Primera página',
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1 ? () => onPageChanged?.call(currentPage - 1) : null,
            tooltip: 'Anterior',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              'Página $currentPage de $_totalPages',
              style: AppTypography.labelMd,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < _totalPages ? () => onPageChanged?.call(currentPage + 1) : null,
            tooltip: 'Siguiente',
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: currentPage < _totalPages ? () => onPageChanged?.call(_totalPages) : null,
            tooltip: 'Última página',
          ),
        ],
      ),
    );
  }
}
