import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_typography.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.obscureText = false,
    this.readOnly    = false,
    this.enabled     = true,
    this.autofocus   = false,
    this.maxLines    = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
  });

  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:       controller,
      focusNode:        focusNode,
      onChanged:        onChanged,
      onFieldSubmitted: onSubmitted,
      validator:        validator,
      obscureText:      obscureText,
      readOnly:         readOnly,
      enabled:          enabled,
      autofocus:        autofocus,
      maxLines:         obscureText ? 1 : maxLines,
      minLines:         minLines,
      maxLength:        maxLength,
      keyboardType:     keyboardType,
      textInputAction:  textInputAction,
      inputFormatters:  inputFormatters,
      style:            AppTypography.bodyMd,
      decoration: InputDecoration(
        labelText:  label,
        hintText:   hint,
        helperText: helperText,
        errorText:  errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
        suffixIcon: suffixIcon,
        prefix:     prefix,
        suffix:     suffix,
        counterText: maxLength != null ? null : '',
      ),
    );
  }
}
