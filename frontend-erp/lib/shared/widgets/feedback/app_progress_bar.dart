import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,   // 0.0 a 1.0
    this.label,
    this.sublabel,
    this.color,
    this.height = 8.0,
    this.showPercentage = true,
  });

  final double value;
  final String? label;
  final String? sublabel;
  final Color? color;
  final double height;
  final bool showPercentage;

  Color get _color {
    if (color != null) return color!;
    if (value >= 0.8) return AppColors.success;
    if (value >= 0.5) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercentage)
          Row(
            children: [
              if (label != null)
                Expanded(child: Text(label!, style: AppTypography.labelMd)),
              if (showPercentage)
                Text('$pct%',
                    style: AppTypography.labelMd.copyWith(color: _color)),
            ],
          ),
        if (label != null || showPercentage)
          const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: LinearProgressIndicator(
            value:            value.clamp(0.0, 1.0),
            minHeight:        height,
            backgroundColor:  AppColors.border,
            valueColor:       AlwaysStoppedAnimation(_color),
          ),
        ),
        if (sublabel != null) ...[
          const SizedBox(height: 2),
          Text(sublabel!, style: AppTypography.caption),
        ],
      ],
    );
  }
}
