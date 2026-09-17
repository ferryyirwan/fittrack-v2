import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

import '../../core/widgets/common/custom_back_button.dart';
import '../../core/widgets/common/glass_card.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/primary_button.dart';
import '../../core/widgets/common/section_header.dart';

class TimerScreen extends StatefulWidget {
  final bool showBackButton;

  const TimerScreen({
    super.key,
    this.showBackButton = true,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}


class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  int totalSeconds = 60;
  int remainingSeconds = 60;
  bool isRunning = false;
  Timer? _timer;

  late AnimationController _pulseController;

  final List<Map<String, dynamic>> presets = [
    {"label": "30s Rest", "seconds": 30, "icon": Icons.bolt_rounded, "color": Colors.orange},
    {"label": "60s Rest", "seconds": 60, "icon": Icons.timer_rounded, "color": AppColors.primary},
    {"label": "90s Set", "seconds": 90, "icon": Icons.fitness_center_rounded, "color": Colors.deepOrangeAccent},
    {"label": "3m Boxing", "seconds": 180, "icon": Icons.sports_mma_rounded, "color": Colors.redAccent},
    {"label": "5m Warmup", "seconds": 300, "icon": Icons.directions_run_rounded, "color": Colors.green},
    {"label": "10m Cardio", "seconds": 600, "icon": Icons.favorite_rounded, "color": Colors.blueAccent},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  void _startTimer() {
    if (isRunning) return;
    if (remainingSeconds <= 0) {
      remainingSeconds = totalSeconds;
    }

    setState(() {
      isRunning = true;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
        if (remainingSeconds <= 3 && remainingSeconds > 0) {
          HapticFeedback.mediumImpact();
        }
      } else {
        _timer?.cancel();
        setState(() {
          isRunning = false;
        });
        HapticFeedback.heavyImpact();
        _showFinishedModal();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      remainingSeconds = totalSeconds;
    });
  }

  void _setPreset(int seconds) {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = seconds;
      remainingSeconds = seconds;
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

  void _showFinishedModal() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(28),
          borderRadius: 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF922D), Color(0xFFFF6B00)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.alarm_on_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Time's Up!",
                style: context.heading1.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 8),
              Text(
                "Great job! You've completed your timer interval. Ready to push further?",
                textAlign: TextAlign.center,
                style: context.bodyMedium.copyWith(height: 1.4),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: "Back to Timer",
                icon: Icons.refresh_rounded,
                onPressed: () {
                  Navigator.pop(context);
                  _resetTimer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds > 0 ? (remainingSeconds / totalSeconds).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
                child: Row(
                  children: [
                    if (widget.showBackButton) const CustomBackButton(),
                    if (widget.showBackButton) const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Workout Timer",
                        style: context.heading2.copyWith(fontSize: 22),
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
                      /// CIRCULAR PROGRESS & TIME DISPLAY
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 260,
                          height: 260,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              /// BACKGROUND RING
                              SizedBox(
                                width: 250,
                                height: 250,
                                child: CircularProgressIndicator(
                                  value: 1.0,
                                  strokeWidth: 14,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.isDark
                                        ? Colors.white.withOpacity(0.06)
                                        : Colors.grey.withOpacity(0.12),
                                  ),
                                ),
                              ),

                              /// ANIMATED PROGRESS RING
                              SizedBox(
                                width: 250,
                                height: 250,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: progress, end: progress),
                                  duration: const Duration(milliseconds: 300),
                                  builder: (context, val, _) {
                                    return CircularProgressIndicator(
                                      value: val,
                                      strokeWidth: 14,
                                      strokeCap: StrokeCap.round,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        remainingSeconds <= 5 && isRunning
                                            ? Colors.redAccent
                                            : AppColors.primary,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              /// INNER TEXT
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (context, child) {
                                      final scale = (isRunning && remainingSeconds <= 5)
                                          ? 1.0 + (_pulseController.value * 0.08)
                                          : 1.0;
                                      return Transform.scale(
                                        scale: scale,
                                        child: Text(
                                          _formatTime(remainingSeconds),
                                          style: context.heading1.copyWith(
                                            fontSize: 52,
                                            fontWeight: FontWeight.w900,
                                            color: remainingSeconds <= 5 && isRunning
                                                ? Colors.redAccent
                                                : context.textColor,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isRunning
                                          ? AppColors.primary.withOpacity(0.15)
                                          : context.isDark
                                              ? Colors.white.withOpacity(0.08)
                                              : Colors.grey.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isRunning ? "ACTIVE" : "PAUSED / READY",
                                      style: TextStyle(
                                        color: isRunning ? AppColors.primary : context.textSecondaryColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// QUICK ADJUST BUTTONS (+/- TIME)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAdjustChip("-30s", () => _adjustTime(-30)),
                          const SizedBox(width: 10),
                          _buildAdjustChip("-10s", () => _adjustTime(-10)),
                          const SizedBox(width: 10),
                          _buildAdjustChip("+10s", () => _adjustTime(10)),
                          const SizedBox(width: 10),
                          _buildAdjustChip("+30s", () => _adjustTime(30)),
                        ],
                      ),

                      const SizedBox(height: 32),

                      /// MAIN CONTROLS (START / PAUSE / RESET)
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: isRunning ? "Pause" : "Start Timer",
                              icon: isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              height: 54,
                              onPressed: isRunning ? _pauseTimer : _startTimer,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _resetTimer,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 54,
                                padding: const EdgeInsets.symmetric(horizontal: 22),
                                decoration: BoxDecoration(
                                  color: context.cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: context.borderColor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.restart_alt_rounded,
                                      color: context.textColor,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Reset",
                                      style: context.bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: context.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      /// PRESET TIMERS
                      const SectionHeader(title: "Quick Presets"),
                      const SizedBox(height: 14),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: presets.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (context, index) {
                          final preset = presets[index];
                          final isSelected = totalSeconds == preset["seconds"] && remainingSeconds == preset["seconds"] && !isRunning;
                          final color = preset["color"] as Color;

                          return GestureDetector(
                            onTap: () => _setPreset(preset["seconds"]),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [color.withOpacity(0.9), color],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: isSelected ? null : context.cardColor,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : color.withOpacity(0.3),
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    preset["icon"],
                                    color: isSelected ? Colors.white : color,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    preset["label"],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : context.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),
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

  Widget _buildAdjustChip(String label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
