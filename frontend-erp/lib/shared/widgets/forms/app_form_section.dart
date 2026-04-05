import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Agrupa campos de un formulario en secciones con título.
/// Uso: dentro de AppModal o AppSideSheet.
class AppFormSection extends StatelessWidget {
  const AppFormSection({
    super.key,
    required this.children,
    this.title,
    this.description,
    this.spacing = AppSpacing.lg,
  });

  final List<Widget> children;
  final String? title;
  final String? description;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: AppTypography.labelLg.copyWith(color: AppColors.textSecondary)),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(description!, style: AppTypography.caption),
          ],
          const SizedBox(height: AppSpacing.md),
        ],
        ...children.map((child) => Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: child,
        )),
      ],
    );
  }
}

/// Fila de dos campos lado a lado (responsive: en móvil se apilan)
class AppFormRow extends StatelessWidget {
  const AppFormRow({
    super.key,
    required this.children,
    this.spacing = AppSpacing.lg,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 600;

    if (isNarrow) {
      return Column(
        children: children
            .map((c) => Padding(padding: EdgeInsets.only(bottom: spacing), child: c))
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .asMap()
          .entries
          .map((e) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: e.key > 0 ? spacing : 0),
                  child: e.value,
                ),
              ))
          .toList(),
    );
  }
}

/// Etiqueta de campo con indicador de requerido/opcional
class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
    this.hint,
  });

  final String label;
  final bool isRequired;
  final String? hint; // tooltip de ayuda

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Text(label, style: AppTypography.labelMd),
          if (isRequired)
            Text(' *', style: AppTypography.labelMd.copyWith(color: AppColors.error))
          else
            Text(
              '  (opcional)',
              style: AppTypography.caption.copyWith(color: AppColors.textDisabled),
            ),
          if (hint != null) ...[
            const SizedBox(width: AppSpacing.xs),
            Tooltip(
              message: hint!,
              child: const Icon(Icons.help_outline, size: 14, color: AppColors.textDisabled),
            ),
          ],
        ],
      ),
    );
  }
}
