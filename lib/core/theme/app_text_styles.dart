import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // =========================
  // Headings
  // =========================

  static final TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // =========================
  // Body
  // =========================

  static final TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static final TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // =========================
  // Button
  // =========================

  static final TextStyle button = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  // =========================
  // Caption
  // =========================

  static final TextStyle caption = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // =========================
  // Dynamic Context Getters
  // =========================

  static TextStyle heading1Of(BuildContext context) => heading1.copyWith(color: context.textColor);
  static TextStyle heading2Of(BuildContext context) => heading2.copyWith(color: context.textColor);
  static TextStyle heading3Of(BuildContext context) => heading3.copyWith(color: context.textColor);
  static TextStyle bodyLargeOf(BuildContext context) => bodyLarge.copyWith(color: context.textColor);
  static TextStyle bodyMediumOf(BuildContext context) => bodyMedium.copyWith(color: context.textSecondaryColor);
  static TextStyle bodySmallOf(BuildContext context) => bodySmall.copyWith(color: context.textSecondaryColor);
  static TextStyle captionOf(BuildContext context) => caption.copyWith(color: context.textSecondaryColor);
}

extension AppTextStyleExtension on BuildContext {
  TextStyle get heading1 => AppTextStyles.heading1Of(this);
  TextStyle get heading2 => AppTextStyles.heading2Of(this);
  TextStyle get heading3 => AppTextStyles.heading3Of(this);
  TextStyle get bodyLarge => AppTextStyles.bodyLargeOf(this);
  TextStyle get bodyMedium => AppTextStyles.bodyMediumOf(this);
  TextStyle get bodySmall => AppTextStyles.bodySmallOf(this);
  TextStyle get caption => AppTextStyles.captionOf(this);
  TextStyle get buttonStyle => AppTextStyles.button;
}