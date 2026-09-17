import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppGradients {
  AppGradients._();

  /// Main background gradient
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF141420),
      AppColors.background,
    ],
  );

  /// Primary orange gradient
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF9838),
      AppColors.primary,
    ],
  );
}