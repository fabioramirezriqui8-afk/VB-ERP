import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class TimelineEvent {
  const TimelineEvent({
    required this.title,
    required this.date,
    this.description,
    this.actor,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String date;
  final String? description;
  final String? actor;
  final IconData? icon;
  final Color? iconColor;
}

class AppTimeline extends StatelessWidget {
  const AppTimeline({super.key, required this.events});
  final List<TimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (_, i) => _TimelineItem(
        event:  events[i],
        isLast: i == events.length - 1,
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event, required this.isLast});
  final TimelineEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = event.iconColor ?? AppColors.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Línea + punto
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color:  color.withOpacity(0.12),
                    shape:  BoxShape.circle,
                    border: Border.all(color: color, width: 1.5),
                  ),
                  child: Icon(
                    event.icon ?? Icons.circle,
                    size: 14, color: color,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: AppColors.border,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Contenido
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xl2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(event.title, style: AppTypography.labelMd),
                      ),
                      Text(event.date, style: AppTypography.caption),
                    ],
                  ),
                  if (event.actor != null) ...[
                    const SizedBox(height: 2),
                    Text(event.actor!,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        )),
                  ],
                  if (event.description != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(event.description!, style: AppTypography.bodyMd),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
