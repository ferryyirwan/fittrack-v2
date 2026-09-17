import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_page_transitions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common/primary_button.dart';
import '../../../data/exercise_data.dart';
import '../../exercise/exercise_screen.dart';
import '../../../core/utils/workout_of_day.dart';

class TodayWorkoutCard extends StatelessWidget {
  const TodayWorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final todayWorkout = WorkoutOfDay.today();
    final isDark = context.isDark;

    var exercises = exerciseData.where((exercise) {
      return todayWorkout["category"] == "All" ||
          exercise.category == todayWorkout["category"];
    }).toList();

    if (exercises.isEmpty) {
      exercises = exerciseData.where((e) => e.category == "Abs" || e.category == "All").take(3).toList();
    }

    final totalExercises = exercises.length;
    final totalMinutes = exercises.fold<int>(
      0,
      (sum, exercise) =>
          sum + (int.tryParse(exercise.duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 15),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.45),
          width: 1.5,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.22),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Stack(
        children: [
          // Background subtle glow circle behind illustration
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LEFT CONTENT
              Expanded(
                flex: 11,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Badges Row
                    Row(
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF922D), Color(0xFFFF5200)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bolt_rounded,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "TODAY'S MASTER PLAN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Main Title
                    Text(
                      todayWorkout["title"]!,
                      style: context.heading1.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Sleek Glass Stat Pills
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.fitness_center_rounded,
                                size: 13,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$totalExercises Exercises",
                                style: context.bodyMedium.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.schedule_rounded,
                                size: 13,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$totalMinutes Mins",
                                style: context.bodyMedium.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      height: 44,
                      width: 145,
                      child: PrimaryButton(
                        text: "Start Workout",
                        icon: Icons.play_arrow_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            AppPageTransitions.slideUp(
                              ExerciseScreen(
                                category: todayWorkout["category"]!,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // RIGHT IMAGE
              Expanded(
                flex: 7,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    todayWorkout["image"]!,
                    height: 175,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
