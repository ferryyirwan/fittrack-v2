import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/custom_back_button.dart';
import '../../core/widgets/common/glass_card.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/primary_button.dart';
import '../../models/exercise.dart';
import 'widgets/exercise_info_chip.dart';
import '../../data/exercise_data.dart';
import '../workout_session/workout_session_screen.dart';
import '../../services/favorite_service.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  bool isFavorite = false;
  int selectedSets = 4;
  late int customWorkSeconds;
  late int customRestSeconds;

  @override
  void initState() {
    super.initState();
    customWorkSeconds = widget.exercise.workSeconds;
    customRestSeconds = widget.exercise.restSeconds;
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final favorite =
        await FavoriteService.instance.isFavorite(widget.exercise.title);
    if (!mounted) return;
    setState(() {
      isFavorite = favorite;
    });
  }

  List<String> _getTargetMuscles(String category) {
    switch (category.toLowerCase()) {
      case 'chest':
        return [
          'Pectoralis Major',
          'Anterior Deltoids',
          'Triceps Brachii',
          'Serratus Anterior'
        ];
      case 'back':
        return [
          'Latissimus Dorsi',
          'Rhomboids',
          'Biceps Brachii',
          'Trapezius'
        ];
      case 'legs':
        return [
          'Quadriceps',
          'Hamstrings',
          'Gluteus Maximus',
          'Gastrocnemius (Calves)'
        ];
      case 'arms':
        return [
          'Biceps Brachii',
          'Triceps Brachii',
          'Brachialis',
          'Forearm Flexors'
        ];
      case 'abs':
        return [
          'Rectus Abdominis',
          'External Obliques',
          'Transverse Abdominis',
          'Core Stabilizers'
        ];
      default:
        return ['Full Body Stabilizers', 'Core', 'Primary Movers'];
    }
  }

  List<String> _getExerciseBenefits(String category) {
    switch (category.toLowerCase()) {
      case 'chest':
        return [
          'Builds upper body pushing power and definition',
          'Strengthens shoulder and elbow joint stability',
          'Improves posture and muscular endurance'
        ];
      case 'back':
        return [
          'Develops back V-taper width and thickness',
          'Counteracts poor sitting posture and slouching',
          'Significantly improves pulling and grip strength'
        ];
      case 'legs':
        return [
          'Boosts overall metabolic rate and calorie burn',
          'Enhances athletic explosiveness and jump height',
          'Strengthens knee and hip joint resilience'
        ];
      case 'arms':
        return [
          'Sculpts and defines arm musculature',
          'Improves grip and lifting capacity for daily tasks',
          'Enhances tendon and elbow joint strength'
        ];
      case 'abs':
        return [
          'Protects the lower back from strain and injury',
          'Enhances balance, agility, and overall coordination',
          'Builds a strong, sculpted midsection'
        ];
      default:
        return [
          'Improves cardiovascular and muscular stamina',
          'Burns high calories while toning functional muscle',
          'Enhances daily functional fitness and vitality'
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final subColor = context.textSecondaryColor;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HERO IMAGE (Back button inside, Favorite icon moved outside!)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Hero(
                        tag: widget.exercise.title,
                        child: Image.asset(
                          widget.exercise.image,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /// Back Button
                    Positioned(
                      top: 16,
                      left: 16,
                      child: const CustomBackButton(),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                /// TITLE & FAVORITE ICON OUTSIDE IMAGE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.exercise.title,
                        style: context.heading1.copyWith(color: textColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: isFavorite
                            ? Colors.red.withOpacity(0.15)
                            : isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.grey.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await FavoriteService.instance
                              .toggleFavorite(widget.exercise.title);
                          final favorite = await FavoriteService.instance
                              .isFavorite(widget.exercise.title);
                          if (!mounted) return;
                          setState(() {
                            isFavorite = favorite;
                          });
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : textColor,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: AppSpacing.lg),

                /// INFO CHIPS
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ExerciseInfoChip(
                      icon: Icons.fitness_center,
                      label: widget.exercise.category,
                    ),
                    ExerciseInfoChip(
                      icon: Icons.trending_up,
                      label: widget.exercise.level,
                    ),
                    ExerciseInfoChip(
                      icon: Icons.schedule,
                      label: widget.exercise.duration,
                    ),
                    ExerciseInfoChip(
                      icon: Icons.local_fire_department,
                      label: widget.exercise.calories,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                /// START WORKOUT BUTTON (ABOVE DESCRIPTION AS REQUESTED)
                PrimaryButton(
                  text: "Start Workout ($selectedSets Sets)",
                  icon: Icons.play_arrow_rounded,
                  onPressed: () {
                    final exercises = exerciseData
                        .where(
                          (e) => e.category == widget.exercise.category,
                        )
                        .toList();

                    final currentIndex = exercises.indexWhere(
                      (e) => e.title == widget.exercise.title,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutSessionScreen(
                          exercises: exercises,
                          initialIndex: currentIndex,
                          targetSets: selectedSets,
                          customWorkSeconds: customWorkSeconds,
                          customRestSeconds: customRestSeconds,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.xl),

                /// DESCRIPTION
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.description_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Description",
                            style: context.heading3.copyWith(color: textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        widget.exercise.description,
                        style: context.bodyMedium.copyWith(
                          color: subColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                /// WORKOUT CONFIGURATION (SETS & TIME)
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.tune_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              "Workout Configuration",
                              style: context.heading3.copyWith(color: textColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Target Sets:",
                        style: context.bodyMedium.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [3, 4, 5].map((sets) {
                          final isSel = selectedSets == sets;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSets = sets;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: sets == 5 ? 0 : 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? AppColors.primary
                                      : isDark
                                          ? Colors.white.withOpacity(0.05)
                                          : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSel
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "$sets Sets",
                                    style: TextStyle(
                                      color: isSel
                                          ? Colors.white
                                          : textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimeAdjuster(
                              title: "Work Time",
                              seconds: customWorkSeconds,
                              icon: Icons.timer_rounded,
                              color: AppColors.primary,
                              onDecrease: () {
                                if (customWorkSeconds > 15) {
                                  setState(() => customWorkSeconds -= 5);
                                }
                              },
                              onIncrease: () {
                                setState(() => customWorkSeconds += 5);
                              },
                              textColor: textColor,
                              subColor: subColor,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTimeAdjuster(
                              title: "Rest Time",
                              seconds: customRestSeconds,
                              icon: Icons.pause_circle_rounded,
                              color: Colors.blueAccent,
                              onDecrease: () {
                                if (customRestSeconds > 5) {
                                  setState(() => customRestSeconds -= 5);
                                }
                              },
                              onIncrease: () {
                                setState(() => customRestSeconds += 5);
                              },
                              textColor: textColor,
                              subColor: subColor,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                /// TARGET MUSCLES & BENEFITS
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.accessibility_new_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              "Target Muscles & Benefits",
                              style: context.heading3.copyWith(color: textColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Primary Muscle Groups Activated:",
                        style: context.bodyMedium.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _getTargetMuscles(widget.exercise.category)
                            .map(
                              (muscle) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  muscle,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Key Benefits:",
                        style: context.bodyMedium.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._getExerciseBenefits(widget.exercise.category).map(
                        (benefit) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: context.bodyMedium.copyWith(
                                    color: subColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                /// HOW TO PERFORM
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.format_list_numbered_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              "How To Perform",
                              style: context.heading3.copyWith(color: textColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...List.generate(
                        widget.exercise.instructions.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 13,
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.exercise.instructions[index],
                                    style: context.bodyMedium.copyWith(
                                      color: subColor,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                /// PRO TRAINER TIP
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E1E24)
                        : Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lightbulb_rounded,
                          color: Colors.orange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pro Trainer Tip & Breathing",
                              style: context.heading3.copyWith(
                                fontSize: 16,
                                color: isDark
                                    ? Colors.orangeAccent
                                    : Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Maintain strict form on every repetition. Exhale steadily as you exert effort (pushing/pulling), and inhale smoothly as you return to the starting position. Quality of movement always beats quantity!",
                              style: context.bodyMedium.copyWith(
                                color: subColor,
                                fontSize: 13,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeAdjuster({
    required String title,
    required int seconds,
    required IconData icon,
    required Color color,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
    required Color textColor,
    required Color subColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: subColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${seconds}s",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundBtn(Icons.remove, onDecrease, color),
              const SizedBox(width: 10),
              _buildRoundBtn(Icons.add, onIncrease, color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundBtn(IconData icon, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}