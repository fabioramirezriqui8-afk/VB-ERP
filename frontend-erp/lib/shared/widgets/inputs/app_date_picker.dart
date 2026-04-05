import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';

class AppDatePicker extends StatelessWidget {
  const AppDatePicker({
    super.key,
    required this.onChanged,
    this.value,
    this.label,
    this.hint = 'Seleccionar fecha',
    this.firstDate,
    this.lastDate,
    this.errorText,
    this.enabled = true,
  });

  final ValueChanged<DateTime?> onChanged;
  final DateTime? value;
  final String? label;
  final String hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? errorText;
  final bool enabled;

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      enabled: enabled,
      controller: TextEditingController(text: value != null ? _format(value!) : ''),
      style: AppTypography.bodyMd,
      decoration: InputDecoration(
        labelText:   label,
        hintText:    hint,
        errorText:   errorText,
        suffixIcon:  const Icon(Icons.calendar_today_outlined, size: 18),
      ),
      onTap: enabled
          ? () async {
              final picked = await showDatePicker(
                context:   context,
                initialDate: value ?? DateTime.now(),
                firstDate: firstDate ?? DateTime(2000),
                lastDate:  lastDate  ?? DateTime(2100),
              );
              onChanged(picked);
            }
          : null,
    );
  }
}
