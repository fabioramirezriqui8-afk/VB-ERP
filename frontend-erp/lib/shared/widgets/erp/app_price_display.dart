import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AppPriceDisplay extends StatelessWidget {
  const AppPriceDisplay({
    super.key,
    required this.amount,
    this.currency      = 'S/',
    this.originalPrice,  // precio antes del descuento (tachado)
    this.taxLabel,       // ej: "IGV 18%"
    this.taxAmount,
    this.size           = PriceSize.md,
    this.color,
  });

  final double amount;
  final String currency;
  final double? originalPrice;
  final String? taxLabel;
  final double? taxAmount;
  final PriceSize size;
  final Color? color;

  String _fmt(double v) =>
      '$currency ${v.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  Widget build(BuildContext context) {
    final mainStyle = switch (size) {
      PriceSize.sm => AppTypography.labelLg,
      PriceSize.md => AppTypography.h4,
      PriceSize.lg => AppTypography.h2,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _fmt(amount),
              style: mainStyle.copyWith(color: color ?? AppColors.textPrimary),
            ),
            if (originalPrice != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                _fmt(originalPrice!),
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.textDisabled,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
        if (taxLabel != null && taxAmount != null)
          Text(
            '$taxLabel: ${_fmt(taxAmount!)}',
            style: AppTypography.caption,
          ),
      ],
    );
  }
}

enum PriceSize { sm, md, lg }
