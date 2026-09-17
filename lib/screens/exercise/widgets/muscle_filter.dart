import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class MuscleFilter extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const MuscleFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  IconData _getCategoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'all':
        return Icons.grid_view_rounded;
      case 'chest':
        return Icons.fitness_center_rounded;
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
    final categories = [
      "All",
      "Chest",
      "Back",
      "Legs",
      "Arms",
      "Abs",
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => onCategorySelected(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFF922D), Color(0xFFFF6B00)],
                        )
                      : null,
                  color: isSelected ? null : context.cardColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : context.borderColor,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category,
                      style: context.bodyMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : context.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}