import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../theme/app_gradients.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppGradients.background
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF4F6FA),
                  Color(0xFFEAEEF6),
                ],
              ),
      ),
      child: child,
    );
  }
}