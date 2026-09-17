import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ExerciseInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const ExerciseInfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? AppColors.border.withOpacity(.4)
              : Colors.black.withOpacity(0.12),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 18,
          ),

          const SizedBox(width: 8),

          Text(
            label,
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textColor,
            ),
          ),
        ],
      ),
    );

  }
}