import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class StatusStep {
  const StatusStep({required this.label, this.sublabel, this.icon});
  final String label;
  final String? sublabel; // ej: fecha en que ocurrió
  final IconData? icon;
}

class AppStatusStepper extends StatelessWidget {
  const AppStatusStepper({
    super.key,
    required this.steps,
    required this.currentStep,  // índice del paso activo
    this.isHorizontal = true,
  });

  final List<StatusStep> steps;
  final int currentStep;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    return isHorizontal
        ? _HorizontalStepper(steps: steps, currentStep: currentStep)
        : _VerticalStepper(steps: steps, currentStep: currentStep);
  }
}

class _HorizontalStepper extends StatelessWidget {
  const _HorizontalStepper({required this.steps, required this.currentStep});
  final List<StatusStep> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: steps.asMap().entries.expand((e) {
        final i     = e.key;
        final step  = e.value;
        final done  = i < currentStep;
        final active = i == currentStep;

        return [
          _StepDot(step: step, done: done, active: active, index: i),
          if (i < steps.length - 1)
            Expanded(
              child: Container(
                height: 2,
                color: done ? AppColors.primary : AppColors.border,
              ),
            ),
        ];
      }).toList(),
    );
  }
}

class _VerticalStepper extends StatelessWidget {
  const _VerticalStepper({required this.steps, required this.currentStep});
  final List<StatusStep> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.asMap().entries.map((e) {
        final i      = e.key;
        final step   = e.value;
        final done   = i < currentStep;
        final active = i == currentStep;
        final isLast = i == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _StepDot(step: step, done: done, active: active, index: i, showLabel: false),
                if (!isLast)
                  Container(width: 2, height: 32, color: done ? AppColors.primary : AppColors.border),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xl2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step.label,
                        style: active
                            ? AppTypography.labelMd.copyWith(color: AppColors.primary)
                            : AppTypography.labelMd),
                    if (step.sublabel != null)
                      Text(step.sublabel!, style: AppTypography.caption),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.step,
    required this.done,
    required this.active,
    required this.index,
    this.showLabel = true,
  });

  final StatusStep step;
  final bool done;
  final bool active;
  final int index;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final color = done || active ? AppColors.primary : AppColors.borderStrong;

    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
                ? AppColors.primary
                : active
                    ? AppColors.primary.withOpacity(0.12)
                    : AppColors.surfaceHover,
            border: Border.all(color: color, width: 2),
          ),
          child: done
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Icon(
                  step.icon ?? Icons.circle,
                  size: 14,
                  color: active ? AppColors.primary : AppColors.textMuted,
                ),
        ),
        if (showLabel) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(step.label,
              style: AppTypography.caption.copyWith(
                color: active ? AppColors.primary : AppColors.textSecondary,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              )),
          if (step.sublabel != null)
            Text(step.sublabel!, style: AppTypography.caption),
        ],
      ],
    );
  }
}
