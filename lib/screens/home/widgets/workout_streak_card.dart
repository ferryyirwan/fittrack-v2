import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/app_user.dart';

class WorkoutStreakCard extends StatelessWidget {
  final AppUser? user;

  const WorkoutStreakCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final streak = user?.workoutStreak ?? 0;
    final isDark = context.isDark;

    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final todayIndex = (DateTime.now().weekday - 1).clamp(0, 6);

    final lastDate = user?.lastWorkoutDate;
    final isWorkedOutToday = lastDate != null &&
        lastDate.year == DateTime.now().year &&
        lastDate.month == DateTime.now().month &&
        lastDate.day == DateTime.now().day;

    final badgeText = streak >= 7
        ? "PRO ATHLETE 🏆"
        : (streak >= 3
            ? "ON FIRE 🔥"
            : (streak > 0 ? "BUILDING ⚡" : "START NOW 🚀"));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.4),
          width: 1.2,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF922D), Color(0xFFFF5200)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Workout Streak & Activity",
                            style: context.heading3.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: streak > 0 ? Colors.green : Colors.orangeAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  streak > 0
                                      ? "$streak Days Active Streak 🔥"
                                      : "Start your streak today! 🚀",
                                  style: context.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Weekly Activity Bar Graph
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final isToday = index == todayIndex;
              bool isActive = false;

              if (streak > 0) {
                if (isWorkedOutToday) {
                  isActive = index <= todayIndex && (todayIndex - index) < streak;
                } else {
                  isActive = index < todayIndex && (todayIndex - 1 - index) >= 0 && (todayIndex - 1 - index) < streak;
                }
              }

              final barHeight = isActive ? (isToday ? 76.0 : 54.0 + (index * 3.0)) : (isToday ? 44.0 : 28.0);

              return Expanded(
                child: Column(
                  children: [
                    if (isActive)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Icon(
                          isToday ? Icons.local_fire_department_rounded : Icons.check_circle_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      )
                    else if (isToday)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: const Icon(
                          Icons.track_changes_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      )
                    else
                      const SizedBox(height: 20),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      width: 26,
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? const LinearGradient(
                                colors: [Color(0xFFFFB067), Color(0xFFFF6B00)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : (isToday
                                ? LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.35),
                                      AppColors.primary.withOpacity(0.15)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null),
                        color: (isActive || isToday)
                            ? null
                            : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06)),
                        borderRadius: BorderRadius.circular(10),
                        border: isToday
                            ? Border.all(
                                color: isActive ? Colors.white : AppColors.primary,
                                width: 1.5,
                              )
                            : null,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text(
                        days[index],
                        style: context.bodySmall.copyWith(
                          fontSize: 12,
                          fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                          color: isToday
                              ? AppColors.primary
                              : (isActive ? context.textColor : context.textSecondaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 20),
          Divider(color: context.borderColor),
          const SizedBox(height: 12),

          // Footer Progress Banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.tips_and_updates_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Next Milestone: ${((streak ~/ 7) + 1) * 7} Days Streak Goal",
                        style: context.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${((streak % 7) / 7 * 100).toInt()}% Done",
                style: context.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

