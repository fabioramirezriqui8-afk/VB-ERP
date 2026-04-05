import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'app_filter_def.dart';

abstract class AppFilterPanel {
  static Future<void> show({
    required BuildContext context,
    required List<AppFilterDef> filters,
    required List<AppFilterValue> activeValues,
    required void Function(List<AppFilterValue>) onApply,
    required VoidCallback onClear,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (_) => _FilterDialog(
        filters:      filters,
        activeValues: activeValues,
        onApply:      onApply,
        onClear:      onClear,
      ),
    );
  }
}

// ── Dialog principal ──────────────────────────────────────────────────────────

class _FilterDialog extends StatefulWidget {
  const _FilterDialog({
    required this.filters,
    required this.activeValues,
    required this.onApply,
    required this.onClear,
  });
  final List<AppFilterDef>   filters;
  final List<AppFilterValue> activeValues;
  final void Function(List<AppFilterValue>) onApply;
  final VoidCallback onClear;

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late List<AppFilterValue> _current;

  @override
  void initState() {
    super.initState();
    _current = List.from(widget.activeValues);
  }

  void _toggle(AppFilterValue val) {
    setState(() {
      final idx = _current.indexWhere((v) => v == val);
      if (idx >= 0) {
        _current.removeAt(idx);
      } else {
        _current.removeWhere((v) => v.key == val.key &&
            widget.filters.firstWhere((f) => f.key == val.key).type == FilterType.select);
        _current.add(val);
      }
    });
  }

  void _setRange(AppFilterDef def, DateTimeRange range, String label) {
    setState(() {
      _current.removeWhere((v) => v.key == def.key);
      _current.add(AppFilterValue(
        key:          def.key,
        label:        def.label,
        displayValue: label,
        rawValue:     range,
      ));
    });
  }

  void _setNumberRange(AppFilterDef def, double min, double max) {
    setState(() {
      _current.removeWhere((v) => v.key == def.key);
      _current.add(AppFilterValue(
        key:          def.key,
        label:        def.label,
        displayValue: '${def.numberSuffix}${min.toStringAsFixed(0)} – ${def.numberSuffix}${max.toStringAsFixed(0)}',
        rawValue:     {'min': min, 'max': max},
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.tune, size: 16, color: AppColors.accent),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text('Filtros', style: AppTypography.labelLg)),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.lg),

              // Filtros
              ...widget.filters.map((def) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: switch (def.type) {
                  FilterType.select      => _SelectFilter(def: def, current: _current, onToggle: _toggle),
                  FilterType.dateRange   => _DateRangeFilter(def: def, current: _current, onSet: _setRange),
                  FilterType.numberRange => _NumberRangeFilter(def: def, current: _current, onSet: _setNumberRange),
                },
              )),

              // Acciones
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() => _current.clear());
                      widget.onClear();
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                    child: const Text('Limpiar'),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      widget.onApply(_current);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Aplicar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Select ────────────────────────────────────────────────────────────────────

class _SelectFilter extends StatelessWidget {
  const _SelectFilter({required this.def, required this.current, required this.onToggle});
  final AppFilterDef def;
  final List<AppFilterValue> current;
  final void Function(AppFilterValue) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(def.label, style: AppTypography.labelMd.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: def.options.map((opt) {
            final val = AppFilterValue(key: def.key, label: def.label, displayValue: opt, rawValue: opt);
            final active = current.any((v) => v == val);
            return GestureDetector(
              onTap: () => onToggle(val),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color:        active ? AppColors.accent : AppColors.surface,
                  border:       Border.all(color: active ? AppColors.accent : AppColors.border),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(opt, style: AppTypography.labelSm.copyWith(
                  color: active ? AppColors.white : AppColors.textPrimary,
                )),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Date Range con atajos + calendarios ───────────────────────────────────────

class _DateRangeFilter extends StatefulWidget {
  const _DateRangeFilter({required this.def, required this.current, required this.onSet});
  final AppFilterDef def;
  final List<AppFilterValue> current;
  final void Function(AppFilterDef, DateTimeRange, String) onSet;

  @override
  State<_DateRangeFilter> createState() => _DateRangeFilterState();
}

class _DateRangeFilterState extends State<_DateRangeFilter> {
  String? _selectedPreset;
  DateTime? _customFrom;
  DateTime? _customTo;
  DateTime _displayMonth1 = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _displayMonth2 = DateTime(DateTime.now().year, DateTime.now().month + 1);

  static DateTime get _today => DateTime.now();

  static Map<String, DateTimeRange> get _presets => {
    'Hoy':           DateTimeRange(start: DateTime(_today.year, _today.month, _today.day), end: DateTime(_today.year, _today.month, _today.day, 23, 59)),
    'Ayer':          DateTimeRange(start: DateTime(_today.year, _today.month, _today.day - 1), end: DateTime(_today.year, _today.month, _today.day - 1, 23, 59)),
    'Últimos 7 días': DateTimeRange(start: _today.subtract(const Duration(days: 6)), end: _today),
    'Últimos 30 días': DateTimeRange(start: _today.subtract(const Duration(days: 29)), end: _today),
    'Este mes':      DateTimeRange(start: DateTime(_today.year, _today.month, 1), end: _today),
    'Mes anterior':  DateTimeRange(start: DateTime(_today.year, _today.month - 1, 1), end: DateTime(_today.year, _today.month, 0)),
    'Este año':      DateTimeRange(start: DateTime(_today.year, 1, 1), end: _today),
    'Personalizado': DateTimeRange(start: _today, end: _today),
  };

  bool get _isCustom => _selectedPreset == 'Personalizado';

  @override
  void initState() {
    super.initState();
    final active = widget.current.where((v) => v.key == widget.def.key).firstOrNull;
    if (active != null) _selectedPreset = active.displayValue;
  }

  void _selectPreset(String label) {
    setState(() => _selectedPreset = label);
    if (label != 'Personalizado') {
      widget.onSet(widget.def, _presets[label]!, label);
    }
  }

  void _onDayTap(DateTime day) {
    if (!_isCustom) return;
    setState(() {
      if (_customFrom == null || (_customFrom != null && _customTo != null)) {
        _customFrom = day;
        _customTo   = null;
      } else if (day.isBefore(_customFrom!)) {
        _customTo   = _customFrom;
        _customFrom = day;
      } else {
        _customTo = day;
        widget.onSet(widget.def, DateTimeRange(start: _customFrom!, end: _customTo!), 'Personalizado');
      }
    });
  }

  bool _inRange(DateTime day) {
    if (_customFrom == null || _customTo == null) return false;
    return !day.isBefore(_customFrom!) && !day.isAfter(_customTo!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.def.label, style: AppTypography.labelMd.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lista de atajos
              Container(
                width: 140,
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  children: _presets.keys.map((label) {
                    final active = _selectedPreset == label;
                    return GestureDetector(
                      onTap: () => _selectPreset(label),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        color: active ? AppColors.accentLight : Colors.transparent,
                        child: Text(label,
                          style: AppTypography.bodyMd.copyWith(
                            color: active ? AppColors.accent : AppColors.textPrimary,
                            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Calendarios (solo en modo personalizado)
              if (_isCustom)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _MiniCalendar(
                          month:      _displayMonth1,
                          from:       _customFrom,
                          to:         _customTo,
                          inRange:    _inRange,
                          onDayTap:   _onDayTap,
                          onPrev:     () => setState(() {
                            _displayMonth1 = DateTime(_displayMonth1.year, _displayMonth1.month - 1);
                            _displayMonth2 = DateTime(_displayMonth2.year, _displayMonth2.month - 1);
                          }),
                          onNext:     () => setState(() {
                            _displayMonth1 = DateTime(_displayMonth1.year, _displayMonth1.month + 1);
                            _displayMonth2 = DateTime(_displayMonth2.year, _displayMonth2.month + 1);
                          }),
                          showPrev: true,
                          showNext: false,
                        )),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: _MiniCalendar(
                          month:      _displayMonth2,
                          from:       _customFrom,
                          to:         _customTo,
                          inRange:    _inRange,
                          onDayTap:   _onDayTap,
                          onPrev:     () {},
                          onNext:     () => setState(() {
                            _displayMonth1 = DateTime(_displayMonth1.year, _displayMonth1.month + 1);
                            _displayMonth2 = DateTime(_displayMonth2.year, _displayMonth2.month + 1);
                          }),
                          showPrev: false,
                          showNext: true,
                        )),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      _selectedPreset == null
                          ? 'Selecciona un período'
                          : 'Período: $_selectedPreset',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Mini calendario ───────────────────────────────────────────────────────────

class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar({
    required this.month,
    required this.from,
    required this.to,
    required this.inRange,
    required this.onDayTap,
    required this.onPrev,
    required this.onNext,
    required this.showPrev,
    required this.showNext,
  });

  final DateTime  month;
  final DateTime? from;
  final DateTime? to;
  final bool Function(DateTime) inRange;
  final void Function(DateTime) onDayTap;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final bool showPrev;
  final bool showNext;

  static const _days = ['lu', 'ma', 'mi', 'ju', 'vi', 'sá', 'do'];
  static const _months = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // weekday: 1=Mon..7=Sun
    final startOffset = (firstDay.weekday - 1) % 7;

    return Column(
      children: [
        // Header mes
        Row(
          children: [
            if (showPrev)
              GestureDetector(onTap: onPrev,
                child: const Icon(Icons.chevron_left, size: 18, color: AppColors.secondary))
            else
              const SizedBox(width: 18),
            Expanded(
              child: Text(
                '${_months[month.month - 1]}. ${month.year}',
                textAlign: TextAlign.center,
                style: AppTypography.labelMd,
              ),
            ),
            if (showNext)
              GestureDetector(onTap: onNext,
                child: const Icon(Icons.chevron_right, size: 18, color: AppColors.secondary))
            else
              const SizedBox(width: 18),
          ],
        ),
        const SizedBox(height: 8),

        // Días de semana
        Row(
          children: _days.map((d) => Expanded(
            child: Text(d, textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
          )).toList(),
        ),
        const SizedBox(height: 4),

        // Días del mes
        ...List.generate(((startOffset + daysInMonth) / 7).ceil(), (week) {
          return Row(
            children: List.generate(7, (dow) {
              final dayNum = week * 7 + dow - startOffset + 1;
              if (dayNum < 1 || dayNum > daysInMonth) return const Expanded(child: SizedBox(height: 28));
              final day = DateTime(month.year, month.month, dayNum);
              final isFrom = from != null && _sameDay(day, from!);
              final isTo   = to   != null && _sameDay(day, to!);
              final inR    = inRange(day);

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDayTap(day),
                  child: Container(
                    height: 28,
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    decoration: BoxDecoration(
                      color: (isFrom || isTo)
                          ? AppColors.accent
                          : inR ? AppColors.accentLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text('$dayNum',
                        style: AppTypography.caption.copyWith(
                          color: (isFrom || isTo) ? AppColors.white
                              : inR ? AppColors.accent
                              : AppColors.textPrimary,
                          fontWeight: (isFrom || isTo) ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ── Number Range ──────────────────────────────────────────────────────────────

class _NumberRangeFilter extends StatefulWidget {
  const _NumberRangeFilter({required this.def, required this.current, required this.onSet});
  final AppFilterDef def;
  final List<AppFilterValue> current;
  final void Function(AppFilterDef, double, double) onSet;

  @override
  State<_NumberRangeFilter> createState() => _NumberRangeFilterState();
}

class _NumberRangeFilterState extends State<_NumberRangeFilter> {
  late RangeValues _range;

  @override
  void initState() {
    super.initState();
    final active = widget.current.where((v) => v.key == widget.def.key).firstOrNull;
    if (active != null && active.rawValue is Map) {
      _range = RangeValues(active.rawValue['min'] as double, active.rawValue['max'] as double);
    } else {
      _range = RangeValues(widget.def.minValue ?? 0, widget.def.maxValue ?? 1000);
    }
  }

  @override
  Widget build(BuildContext context) {
    final min = widget.def.minValue ?? 0;
    final max = widget.def.maxValue ?? 1000;
    final s   = widget.def.numberSuffix;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.def.label, style: AppTypography.labelMd.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$s${_range.start.toStringAsFixed(0)}',
                style: AppTypography.labelSm.copyWith(color: AppColors.accent)),
            Text('$s${_range.end.toStringAsFixed(0)}',
                style: AppTypography.labelSm.copyWith(color: AppColors.accent)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor:   AppColors.accent,
            inactiveTrackColor: AppColors.border,
            thumbColor:         AppColors.accent,
            overlayColor:       AppColors.accent.withOpacity(0.1),
          ),
          child: RangeSlider(
            values:    _range,
            min:       min,
            max:       max,
            divisions: ((max - min) / 10).round(),
            onChanged: (v) {
              setState(() => _range = v);
              widget.onSet(widget.def, v.start, v.end);
            },
          ),
        ),
      ],
    );
  }
}
