import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.hasError = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 58,
      decoration: BoxDecoration(
        color: hasError
            ? Colors.redAccent.withOpacity(0.12)
            : context.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasError
              ? Colors.redAccent
              : context.borderColor,
          width: hasError ? 1.5 : 1.0,
        ),
        boxShadow: hasError
            ? [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyle(
          color: context.textColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: context.textSecondaryColor.withOpacity(0.6),
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,

          ),
          prefixIcon: Icon(
            prefixIcon,
            color: hasError ? Colors.redAccent : AppColors.primary,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}