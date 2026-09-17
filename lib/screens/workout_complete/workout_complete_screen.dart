import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/primary_button.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';
import '../main/main_screen.dart';

class WorkoutCompleteScreen extends StatefulWidget {
  final int exerciseCount;

  const WorkoutCompleteScreen({
    super.key,
    required this.exerciseCount,
  });

  @override
  State<WorkoutCompleteScreen> createState() =>
      _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState
    extends State<WorkoutCompleteScreen> {

  bool updated = false;

  @override
  void initState() {
    super.initState();
    _updateWorkoutStreak();
  }

  Future<void> _updateWorkoutStreak() async {
    if (updated) return;

    updated = true;

    await UserService.instance.incrementWorkoutStreak();

    if (!mounted) return;

    await context.read<UserProvider>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber,
                  size: 100,
                ),

                const SizedBox(height: AppSpacing.xl),

                Text(
                  "Workout Complete!",
                  style: context.heading1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.md),

                Text(
                  "Great job! You completed\n${widget.exerciseCount} exercises.",
                  textAlign: TextAlign.center,
                  style: context.bodyLarge,
                ),

                const SizedBox(height: AppSpacing.xxl),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Column(
                    children: [

                      const Icon(
                        Icons.local_fire_department,
                        color: AppColors.primary,
                        size: 42,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "${widget.exerciseCount * 150} kcal",
                        style: context.heading2,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Estimated Calories Burned",
                        style: context.bodySmall,
                      ),

                    ],
                  ),
                ),

                const Spacer(),


                PrimaryButton(
                  text: "Back To Home",
                  icon: Icons.home_rounded,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                      ),
                          (route) => false,
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}