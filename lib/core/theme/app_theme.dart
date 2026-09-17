import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_page_transitions.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static const _pageTransitionsTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: SmoothPageTransitionsBuilder(),
      TargetPlatform.iOS: SmoothPageTransitionsBuilder(),
      TargetPlatform.windows: SmoothPageTransitionsBuilder(),
      TargetPlatform.macOS: SmoothPageTransitionsBuilder(),
      TargetPlatform.linux: SmoothPageTransitionsBuilder(),
    },
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    pageTransitionsTheme: _pageTransitionsTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    ),
    fontFamily: 'Poppins',
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1,
      headlineMedium: AppTextStyles.heading2,
      headlineSmall: AppTextStyles.heading3,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.button,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardColor: AppColors.card,
    dividerColor: AppColors.border,
  );

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    pageTransitionsTheme: _pageTransitionsTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
    ),
    fontFamily: 'Poppins',
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1.copyWith(color: AppColors.lightTextPrimary),
      headlineMedium: AppTextStyles.heading2.copyWith(color: AppColors.lightTextPrimary),
      headlineSmall: AppTextStyles.heading3.copyWith(color: AppColors.lightTextPrimary),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.lightTextPrimary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.lightTextSecondary),
      labelLarge: AppTextStyles.button,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextPrimary,
      ),
    ),
    cardColor: AppColors.lightCard,
    dividerColor: AppColors.lightBorder,
  );
}
