import 'dart:math' as math;
import 'package:flutter/material.dart';

class TimerCircle extends StatelessWidget {

  final int totalSeconds;
  final int remainingSeconds;
  final bool isResting;

  const TimerCircle({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.isResting = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds > 0 ? (remainingSeconds / totalSeconds).clamp(0.0, 1.0) : 0.0;

    Color primaryColor;
    Color secondaryColor;

    if (remainingSeconds <= 5) {
      primaryColor = Colors.redAccent;
      secondaryColor = Colors.red;
    } else if (isResting) {
      primaryColor = Colors.greenAccent;
      secondaryColor = Colors.tealAccent.shade700;
    } else {
      primaryColor = const Color(0xFFFF922D);
      secondaryColor = const Color(0xFFFF6B00);
    }

    return SizedBox(
      width: 250,
      height: 250,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: progress, end: progress),
        duration: const Duration(milliseconds: 350),
        builder: (context, value, child) {
          return CustomPaint(
            painter: _TimerPainter(
              progress: value,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),
          );
        },
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  const _TimerPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 16.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    /// Background track ring
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress <= 0) return;

    /// Gradient progress ring
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      colors: [primaryColor, secondaryColor, primaryColor],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    /// Add a subtle glow
    final glowPaint = Paint()
      ..color = primaryColor.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, glowPaint);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}