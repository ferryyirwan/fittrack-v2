import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'timer_circle.dart';

class CountdownTimer extends StatelessWidget {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isResting;

  const CountdownTimer({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.isResting = false,
  });

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    return "${minutes.toString().padLeft(2, "0")}:${secs.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    Color textColor;
    String label;

    if (remainingSeconds <= 5 && remainingSeconds > 0) {
      textColor = Colors.redAccent;
      label = "GET READY!";
    } else if (isResting) {
      textColor = Colors.greenAccent;
      label = "REST INTERVAL";
    } else {
      textColor = AppColors.primary;
      label = "ACTIVE WORK";
    }

    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TimerCircle(
            totalSeconds: totalSeconds,
            remainingSeconds: remainingSeconds,
            isResting: isResting,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: textColor.withOpacity(0.3)),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                formatTime(remainingSeconds),
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 50,
                  color: textColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "${remainingSeconds}s left of ${totalSeconds}s",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}