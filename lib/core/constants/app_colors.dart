import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================
  // Brand
  // =========================

  static const Color primary = Color(0xFFFF7A00);
  static const Color secondary = Color(0xFF7C4DFF);

  // =========================
  // Background (Dark defaults)
  // =========================

  static const Color background = Color(0xFF0D0D14);
  static const Color surface = Color(0xFF151521);
  static const Color card = Color(0xFF1B1B27);

  // =========================
  // Light Background Palette
  // =========================
  static const Color lightBackground = Color(0xFFF4F6FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  // =========================
  // Text
  // =========================

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB8B8C7);

  static const Color lightTextPrimary = Color(0xFF13151F);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // =========================
  // Border
  // =========================

  static const Color border = Color(0xFF2B2B3D);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // =========================
  // Status
  // =========================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFEF4444);
}

extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get backgroundColor => isDark ? AppColors.background : AppColors.lightBackground;
  Color get surfaceColor => isDark ? AppColors.surface : AppColors.lightSurface;
  Color get cardColor => isDark ? AppColors.card : AppColors.lightCard;
  Color get textColor => isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
  Color get textSecondaryColor => isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
  Color get borderColor => isDark ? AppColors.border : AppColors.lightBorder;
}