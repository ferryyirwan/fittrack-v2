import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF922D), Color(0xFFFF6B00)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.fitness_center_rounded,
            size: 46,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        Text(
          "FitTrack",
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.primary,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          title,
          style: context.heading2.copyWith(
            color: context.textColor,
            fontSize: 24,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: context.bodyMedium.copyWith(
              color: context.textSecondaryColor,
              height: 1.4,
            ),
          ),

        ),
      ],
    );
  }
}