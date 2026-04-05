import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';

class AppSelectOption<T> {
  const AppSelectOption({required this.value, required this.label, this.icon});
  final T value;
  final String label;
  final IconData? icon;
}

class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    super.key,
    required this.options,
    required this.onChanged,
    this.value,
    this.label,
    this.hint = 'Seleccionar...',
    this.errorText,
    this.enabled = true,
    this.validator,
  });

  final List<AppSelectOption<T>> options;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? label;
  final String hint;
  final String? errorText;
  final bool enabled;
  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      style: AppTypography.bodyMd,
      decoration: InputDecoration(
        labelText: label,
        hintText:  hint,
        errorText: errorText,
      ),
      items: options
          .map((o) => DropdownMenuItem<T>(
                value: o.value,
                child: Row(
                  children: [
                    if (o.icon != null) ...[
                      Icon(o.icon, size: 16),
                      const SizedBox(width: 8),
                    ],
                    Text(o.label),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
