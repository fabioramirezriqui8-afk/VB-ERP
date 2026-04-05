import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class DateRange {
  const DateRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}

class AppDateRangePicker extends StatelessWidget {
  const AppDateRangePicker({
    super.key,
    required this.onChanged,
    this.value,
    this.label,
    this.hint = 'Seleccionar rango',
    this.enabled = true,
    this.errorText,
  });

  final ValueChanged<DateRange?> onChanged;
  final DateRange? value;
  final String? label;
  final String hint;
  final bool enabled;
  final String? errorText;

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String get _displayText => value != null
      ? '${_format(value!.start)}  →  ${_format(value!.end)}'
      : '';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly:   true,
      enabled:    enabled,
      controller: TextEditingController(text: _displayText),
      style:      AppTypography.bodyMd,
      decoration: InputDecoration(
        labelText:  label,
        hintText:   hint,
        errorText:  errorText,
        prefixIcon: const Icon(Icons.date_range_outlined, size: 18),
        suffixIcon: value != null
            ? IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () => onChanged(null),
              )
            : null,
      ),
      onTap: enabled
          ? () async {
              final picked = await showDateRangePicker(
                context:      context,
                firstDate:    DateTime(2000),
                lastDate:     DateTime(2100),
                initialDateRange: value != null
                    ? DateTimeRange(start: value!.start, end: value!.end)
                    : null,
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx),
                  child: child!,
                ),
              );
              if (picked != null) {
                onChanged(DateRange(start: picked.start, end: picked.end));
              }
            }
          : null,
    );
  }
}
