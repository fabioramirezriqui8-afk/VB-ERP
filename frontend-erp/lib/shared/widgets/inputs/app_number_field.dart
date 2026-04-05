import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_typography.dart';

class AppNumberField extends StatefulWidget {
  const AppNumberField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.validator,
    this.min,
    this.max,
    this.step        = 1,
    this.decimals    = 0,
    this.prefix,       // ej: "S/" para soles
    this.suffix,       // ej: "kg"
    this.showStepper = true,
    this.enabled     = true,
    this.errorText,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<double?>? onChanged;
  final FormFieldValidator<String>? validator;
  final double? min;
  final double? max;
  final double step;
  final int decimals;
  final String? prefix;
  final String? suffix;
  final bool showStepper;
  final bool enabled;
  final String? errorText;

  @override
  State<AppNumberField> createState() => _AppNumberFieldState();
}

class _AppNumberFieldState extends State<AppNumberField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
  }

  double? get _current => double.tryParse(_ctrl.text);

  void _increment() => _setValue((_current ?? 0) + widget.step);
  void _decrement() => _setValue((_current ?? 0) - widget.step);

  void _setValue(double v) {
    if (widget.min != null && v < widget.min!) v = widget.min!;
    if (widget.max != null && v > widget.max!) v = widget.max!;
    final formatted = widget.decimals > 0
        ? v.toStringAsFixed(widget.decimals)
        : v.toInt().toString();
    _ctrl.text = formatted;
    widget.onChanged?.call(v);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _ctrl,
      enabled:    widget.enabled,
      style:      AppTypography.bodyMd,
      keyboardType: TextInputType.numberWithOptions(
        decimal: widget.decimals > 0,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          widget.decimals > 0
              ? RegExp(r'^\d*\.?\d*')
              : RegExp(r'^\d*'),
        ),
      ],
      validator: widget.validator,
      onChanged: (v) => widget.onChanged?.call(double.tryParse(v)),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText:  widget.hint,
        errorText: widget.errorText,
        prefixText: widget.prefix,
        suffixText: widget.suffix,
        prefixStyle: AppTypography.bodyMd,
        suffixStyle: AppTypography.bodyMd,
        suffixIcon: widget.showStepper
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: widget.enabled &&
                            (_current == null ||
                                widget.min == null ||
                                _current! > widget.min!)
                        ? _decrement
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: widget.enabled &&
                            (_current == null ||
                                widget.max == null ||
                                _current! < widget.max!)
                        ? _increment
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
