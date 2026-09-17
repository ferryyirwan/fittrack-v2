import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Expanded(
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: context.borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(.18)
                  : Colors.black.withOpacity(.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: TextStyle(
                color: context.textSecondaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              value,
              style: TextStyle(
                color: context.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}