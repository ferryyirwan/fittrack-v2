import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onClear;
  final bool showClearButton;

  const AppSearchBar({
    super.key,
    this.hintText = "Search...",
    this.controller,
    this.onChanged,
    this.onFilterPressed,
    this.onClear,
    this.showClearButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: context.borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.15 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.md),

          Icon(
            Icons.search_rounded,
            color: context.textSecondaryColor,
          ),

          const SizedBox(width: AppSpacing.sm),

          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: context.bodyLarge,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: context.bodyMedium,
                border: InputBorder.none,
              ),
            ),
          ),

          if (showClearButton && onClear != null)
            IconButton(
              onPressed: onClear,
              icon: const Icon(
                Icons.close_rounded,
                color: AppColors.primary,
              ),
            ),

          if (onFilterPressed != null)
            IconButton(
              onPressed: onFilterPressed,
              icon: const Icon(
                Icons.tune_rounded,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
