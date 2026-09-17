import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import 'glass_card.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String title;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 26,
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: context.textSecondaryColor,
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            value,
            style: context.heading3,
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: context.bodyMedium,
          ),
        ],
      ),
    );
  }
}