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
  final double? width;
  final int flex;
  final Alignment alignment;
}

/// Tabla genérica reutilizable.
/// - Columnas dinámicas con selector de visibilidad
/// - Header azul marino con bordes redondeados
/// - Paginación, selección, loading, vacío
class AppTable<T> extends StatefulWidget {
  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading      = false,
    this.onRowTap,
    this.selectedRows   = const {},
    this.onSelectRow,
    this.onSelectAll,
    this.showCheckbox   = false,
    this.emptyTitle     = 'Sin resultados',
    this.emptyDescription,
    this.emptyIcon      = Icons.table_rows_outlined,
    this.totalItems     = 0,
    this.currentPage    = 1,
    this.pageSize       = 20,
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

  // Índices de columnas visibles — por defecto todas visibles
  late Set<int> _visibleCols;

  @override
  void initState() {
    super.initState();
    _visibleCols = Set.from(
      List.generate(widget.columns.length, (i) => i),
    );
  }

  @override
  void dispose() {
    _vScroll.dispose();
    _hScroll.dispose();
    super.dispose();
  }

  List<AppTableColumn<T>> get _activeCols => [
    for (int i = 0; i < widget.columns.length; i++)
      if (_visibleCols.contains(i)) widget.columns[i],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra superior: contador + selector de columnas
        _buildToolbar(context),
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

  Widget _buildToolbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            '${widget.rows.length} registros',
            style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
          ),
          const Spacer(),
          // Botón selector de columnas
          _ColumnSelector<T>(
            columns:     widget.columns,
            visibleCols: _visibleCols,
            onChanged: (idx, visible) => setState(() {
              visible ? _visibleCols.add(idx) : _visibleCols.remove(idx);
            }),
          ),
        ],
      ),
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
        final double tableWidth =
            constraints.maxWidth > 1000 ? constraints.maxWidth : 1000;

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Scrollbar(
              controller: _vScroll,
              thumbVisibility: true,
              child: Scrollbar(
                controller: _hScroll,
                thumbVisibility: true,
                notificationPredicate: (n) => n.depth == 1,
                child: SingleChildScrollView(
                  controller: _vScroll,
                  child: SingleChildScrollView(
                    controller: _hScroll,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(context),
                          ...List.generate(widget.rows.length, (i) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildRow(context, widget.rows[i], i),
                              if (i < widget.rows.length - 1)
                                const Divider(height: 1, color: AppColors.border),
                            ],
                          )),
                        ],
                      ),
                    ),
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
    return Container(
      color: AppColors.tableHeader,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical:   AppSpacing.md,
      ),
      child: Row(
        children: [
          if (widget.showCheckbox)
            Checkbox(
              value: widget.rows.isNotEmpty &&
                  widget.selectedRows.length == widget.rows.length,
              tristate: true,
              onChanged: (v) => widget.onSelectAll?.call(v ?? false),
              checkColor: AppColors.white,
              side: const BorderSide(color: AppColors.white, width: 1.5),
              activeColor: AppColors.white,
            ),
          // Columna # fija
          SizedBox(
            width: 48,
            child: Text('#', style: AppTypography.labelMd.copyWith(
              color: AppColors.tableHeaderText,
              fontWeight: FontWeight.w600,
            )),
          ),
          ..._activeCols.map((col) => _cellWrapper(
                col,
                Text(col.label, style: AppTypography.labelMd.copyWith(
                  color:      AppColors.tableHeaderText,
                  fontWeight: FontWeight.w600,
                )),
              )),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, T row, int index) {
    final isSelected = widget.selectedRows.contains(row);

    return InkWell(
      onTap:       widget.onRowTap != null ? () => widget.onRowTap!(row) : null,
      hoverColor:  AppColors.tableRowHover,
      child: Container(
        color: isSelected
            ? AppColors.accent.withOpacity(0.08)
            : index.isOdd
                ? AppColors.tableRowEven
                : AppColors.tableRowOdd,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.md,
        ),
        child: Row(
          children: [
            if (widget.showCheckbox)
              Checkbox(
                value:     isSelected,
                onChanged: (v) => widget.onSelectRow?.call(row, v ?? false),
              ),
            // Número de fila
            SizedBox(
              width: 48,
              child: Text(
                '${index + 1}',
                style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
              ),
            ),
            ..._activeCols.map((col) => _cellWrapper(col, col.builder(row))),
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

// ── Selector de columnas ──────────────────────────────────────────────────────

class _ColumnSelector<T> extends StatelessWidget {
  const _ColumnSelector({
    required this.columns,
    required this.visibleCols,
    required this.onChanged,
  });

  final List<AppTableColumn<T>> columns;
  final Set<int> visibleCols;
  final void Function(int idx, bool visible) onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip:    'Columnas visibles',
      icon: const Icon(Icons.view_column_outlined,
          size: 20, color: AppColors.accent),
      color:      AppColors.surface,
      elevation:  2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
      itemBuilder: (_) => List.generate(columns.length, (i) {
        final visible = visibleCols.contains(i);
        return PopupMenuItem<int>(
          value:   i,
          enabled: !(visible && visibleCols.length == 1), // al menos 1 visible
          child: StatefulBuilder(
            builder: (ctx, setLocal) => Row(
              children: [
                Checkbox(
                  value:     visible,
                  onChanged: (v) {
                    onChanged(i, v ?? false);
                    Navigator.pop(ctx);
                  },
                  activeColor: AppColors.accent,
                ),
                const SizedBox(width: 4),
                Text(columns[i].label, style: AppTypography.bodyMd),
              ],
            ),
          ),
        );
      }),
      onSelected: (i) {
        final visible = visibleCols.contains(i);
        if (visible && visibleCols.length == 1) return;
        onChanged(i, !visible);
      },
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
  int get _from       => ((currentPage - 1) * pageSize) + 1;
  int get _to         => (currentPage * pageSize).clamp(0, totalItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical:   AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Text(
            'Mostrando $_from–$_to de $totalItems',
            style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
          ),
          const Spacer(),
          IconButton(
            icon:      const Icon(Icons.first_page),
            onPressed: currentPage > 1 ? () => onPageChanged?.call(1) : null,
            tooltip:   'Primera página',
            color:     AppColors.secondary,
          ),
          IconButton(
            icon:      const Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () => onPageChanged?.call(currentPage - 1)
                : null,
            tooltip: 'Anterior',
            color:   AppColors.secondary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              'Página $currentPage de $_totalPages',
              style: AppTypography.labelMd,
            ),
          ),
          IconButton(
            icon:      const Icon(Icons.chevron_right),
            onPressed: currentPage < _totalPages
                ? () => onPageChanged?.call(currentPage + 1)
                : null,
            tooltip: 'Siguiente',
            color:   AppColors.secondary,
          ),
          IconButton(
            icon:      const Icon(Icons.last_page),
            onPressed: currentPage < _totalPages
                ? () => onPageChanged?.call(_totalPages)
                : null,
            tooltip: 'Última página',
            color:   AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
