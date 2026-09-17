import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import 'glass_card.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  IconData _getIconForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'chest':
        return Icons.fitness_center;
      case 'back':
        return Icons.accessibility_new_rounded;
      case 'legs':
        return Icons.directions_run_rounded;
      case 'arms':
        return Icons.sports_gymnastics_rounded;
      case 'abs':
        return Icons.self_improvement_rounded;
      default:
        return Icons.bolt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(10),

        borderRadius: 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForCategory(title),
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: context.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}