import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/custom_back_button.dart';

import '../../core/widgets/common/glass_card.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/primary_button.dart';
import '../../models/exercise.dart';
import 'widgets/countdown_timer.dart';
import '../workout_complete/workout_complete_screen.dart';
import '../../services/streak_service.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final int initialIndex;
  final int targetSets;
  final int? customWorkSeconds;
  final int? customRestSeconds;

  const WorkoutSessionScreen({
    super.key,
    required this.exercises,
    this.initialIndex = 0,
    this.targetSets = 1,
    this.customWorkSeconds,
    this.customRestSeconds,
  });

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  late int currentIndex;
  late int currentSet;
  late int totalSeconds;
  late int remainingSeconds;

  bool isRunning = false;
  bool isResting = false;

  Timer? timer;

  Exercise get exercise => widget.exercises[currentIndex];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    currentSet = 1;
    totalSeconds = widget.customWorkSeconds ?? exercise.workSeconds;
    remainingSeconds = totalSeconds;
  }

  void startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
        if (remainingSeconds <= 3 && remainingSeconds > 0) {
          HapticFeedback.mediumImpact();
        }
      } else {
        timer?.cancel();
        setState(() => isRunning = false);
        HapticFeedback.heavyImpact();
        _handleTimerFinished();
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = isResting
          ? (widget.customRestSeconds ?? exercise.restSeconds)
          : (widget.customWorkSeconds ?? exercise.workSeconds);
      remainingSeconds = totalSeconds;
    });
  }

  void _adjustTime(int secondsDelta) {
    setState(() {
      if (!isRunning) {
        totalSeconds = (totalSeconds + secondsDelta).clamp(5, 3600);
        remainingSeconds = totalSeconds;
      } else {
        remainingSeconds = (remainingSeconds + secondsDelta).clamp(1, 3600);
        if (remainingSeconds > totalSeconds) {
          totalSeconds = remainingSeconds;
        }
      }
    });
  }

  void _skipToNext() {
    timer?.cancel();
    setState(() => isRunning = false);
    _handleTimerFinished();
  }

  Future<void> _handleTimerFinished() async {
    if (!isResting) {
      setState(() {
        isResting = true;
        totalSeconds = widget.customRestSeconds ?? exercise.restSeconds;
        remainingSeconds = totalSeconds;
      });
      return;
    }

    if (currentSet < widget.targetSets) {
      setState(() {
        currentSet++;
        isResting = false;
        totalSeconds = widget.customWorkSeconds ?? exercise.workSeconds;
        remainingSeconds = totalSeconds;
      });
      return;
    }

    if (currentIndex < widget.exercises.length - 1) {
      setState(() {
        currentIndex++;
        currentSet = 1;
        isResting = false;
        totalSeconds = widget.customWorkSeconds ?? exercise.workSeconds;
        remainingSeconds = totalSeconds;
      });
    } else {
      await StreakService.instance.completeWorkout();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutCompleteScreen(
            exerciseCount: widget.exercises.length,
          ),
        ),
      );
    }
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressStep = (currentIndex + 1) / widget.exercises.length;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              /// TOP HEADER & PROGRESS BAR
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    const CustomBackButton(),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  isResting
                                      ? "Rest (Set $currentSet/${widget.targetSets})"
                                      : "Set $currentSet/${widget.targetSets} • Ex ${currentIndex + 1}/${widget.exercises.length}",
                                  style: context.heading3.copyWith(fontSize: 15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              Text(
                                "${((progressStep) * 100).toInt()}%",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progressStep,
                              minHeight: 6,
                              backgroundColor: context.isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.grey.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isResting ? Colors.greenAccent : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      /// COUNTDOWN TIMER CIRCLE
                      CountdownTimer(
                        totalSeconds: totalSeconds,
                        remainingSeconds: remainingSeconds,
                        isResting: isResting,
                      ),

                      const SizedBox(height: 20),

                      /// QUICK TIME ADJUSTMENT CHIPS (+/-)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildQuickChip("-15s", () => _adjustTime(-15)),
                          const SizedBox(width: 8),
                          _buildQuickChip("+15s", () => _adjustTime(15)),
                          const SizedBox(width: 8),
                          _buildQuickChip("+30s", () => _adjustTime(30)),
                          const SizedBox(width: 8),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _skipToNext,
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isResting
                                      ? Colors.greenAccent.withOpacity(0.15)
                                      : Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isResting ? Colors.greenAccent : Colors.orange,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isResting ? "Skip Rest" : "Next Set",
                                      style: TextStyle(
                                        color: isResting ? Colors.greenAccent : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.fast_forward_rounded,
                                      size: 14,
                                      color: isResting ? Colors.greenAccent : Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// CURRENT STATE CARD (EXERCISE INFO OR REST GUIDANCE)
                      if (isResting)
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          borderRadius: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.self_improvement_rounded,
                                      color: Colors.greenAccent,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "RECOVERY BREAK",
                                          style: TextStyle(
                                            color: Colors.greenAccent,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Breathe in through nose, out through mouth",
                                          style: context.bodySmall.copyWith(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: context.isDark
                                      ? Colors.white.withOpacity(0.04)
                                      : Colors.grey.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: context.borderColor),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 22),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "UP NEXT",
                                            style: TextStyle(
                                              color: context.textSecondaryColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            currentIndex < widget.exercises.length - 1
                                                ? widget.exercises[currentIndex + 1].title
                                                : "Final Stretch!",
                                            style: context.heading3.copyWith(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          borderRadius: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.asset(
                                      exercise.image,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                exercise.category.toUpperCase(),
                                                style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                exercise.level,
                                                style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          exercise.title,
                                          style: context.heading2.copyWith(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (exercise.instructions.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: context.isDark
                                        ? Colors.white.withOpacity(0.03)
                                        : Colors.grey.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: context.borderColor),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.lightbulb_outline_rounded,
                                        size: 18,
                                        color: AppColors.primary.withOpacity(0.8),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          exercise.instructions.first,
                                          style: context.bodySmall.copyWith(
                                            height: 1.4,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      /// MAIN ACTION BUTTONS (START/PAUSE & RESET)
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: PrimaryButton(
                              text: isRunning ? "Pause" : "Start",
                              icon: isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              height: 54,
                              onPressed: isRunning ? pauseTimer : startTimer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: resetTimer,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: context.cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: context.borderColor),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.restart_alt_rounded,
                                        color: context.textColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Reset",
                                        style: context.bodyMedium.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: context.isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.grey.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.borderColor),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: context.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

