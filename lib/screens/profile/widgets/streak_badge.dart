import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(.18),
            Colors.deepOrange.withOpacity(.10),
          ],
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: AppColors.primary.withOpacity(.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.orange,
            size: 22,
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Workout Streak",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Text(
                "$streak Days",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}