import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common/glass_card.dart';
import '../../../models/workout_schedule.dart';

class ScheduleCard extends StatelessWidget {
  final WorkoutSchedule schedule;
  final VoidCallback? onTap;
  final bool isSelected;

  const ScheduleCard({
    super.key,
    required this.schedule,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      borderRadius: 22,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(22),
              )
            : null,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: schedule.category == "Rest"
                    ? Colors.blue.withOpacity(0.15)
                    : AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                schedule.icon,
                color: schedule.category == "Rest"
                    ? Colors.blueAccent
                    : AppColors.primary,
                size: 26,
              ),
            ),

            const SizedBox(width: AppSpacing.lg),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          schedule.day,
                          style: context.heading3.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Selected",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    schedule.title,
                    style: context.bodyMedium.copyWith(
                      color: schedule.category == "Rest"
                          ? Colors.blueAccent
                          : context.textSecondaryColor,
                      fontWeight: schedule.category == "Rest"
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: context.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}