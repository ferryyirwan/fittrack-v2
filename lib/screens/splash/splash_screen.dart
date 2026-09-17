import 'dart:async';

import 'package:flutter/material.dart';


import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/gradient_background.dart';

import '../auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _subtitleSlide;
  late Animation<double> _subtitleFade;
  late Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Staggered intervals
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.60, curve: Curves.easeIn),
      ),
    );

    _subtitleSlide = Tween<double>(begin: 25.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.40, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.40, 0.75, curve: Curves.easeIn),
      ),
    );

    _loaderFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    _entranceController.forward();

    Timer(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const AuthGate(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            // Ambient Glow Orb 1 (Top Right)
            Positioned(
              top: -80,
              right: -80,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseController.value * 0.15),
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withOpacity(isDark ? 0.22 : 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Ambient Glow Orb 2 (Bottom Left)
            Positioned(
              bottom: -100,
              left: -100,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + ((1.0 - _pulseController.value) * 0.15),
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.secondary.withOpacity(isDark ? 0.20 : 0.10),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main Content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Glowing Premium Logo Badge
                    AnimatedBuilder(
                      animation: _entranceController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _logoFade.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: child,
                          ),
                        );
                      },
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final pulse = _pulseController.value;
                          return Container(
                            width: 150,
                            height: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.25 + (pulse * 0.18)),
                                  blurRadius: 35 + (pulse * 15),
                                  spreadRadius: 2 + (pulse * 4),
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.15 + (pulse * 0.1)),
                                  blurRadius: 45,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer Glass Ring
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.cardColor.withOpacity(isDark ? 0.6 : 0.8),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.4 + (pulse * 0.3)),
                                      width: 1.5,
                                    ),
                                  ),
                                ),

                                // Inner Gradient Circle
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.primary,
                                        const Color(0xFFFF5200),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Top Left Glass Shine Strip
                                      Positioned(
                                        top: 12,
                                        left: 18,
                                        child: Container(
                                          width: 35,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.28),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      const Center(
                                        child: Icon(
                                          Icons.fitness_center_rounded,
                                          size: 54,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 38),

                    // Title with Gradient Effect & Staggered Animation
                    AnimatedBuilder(
                      animation: _entranceController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _titleFade.value,
                          child: Transform.translate(
                            offset: Offset(0, _titleSlide.value),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                AppColors.primary,
                                Color(0xFFFF922D),
                                AppColors.secondary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: Text(
                              "FitTrack Pro",
                              style: context.heading1.copyWith(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.35),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              "V 2 . 0 • P R E M I U M   E D I T I O N",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Subtitle with Staggered Animation
                    AnimatedBuilder(
                      animation: _entranceController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _subtitleFade.value,
                          child: Transform.translate(
                            offset: Offset(0, _subtitleSlide.value),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Your Ultimate AI Workout & Health Companion",
                          style: context.bodyMedium.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Sleek Modern Shimmer / Loader Bar
                    AnimatedBuilder(
                      animation: _entranceController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _loaderFade.value,
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 140,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, _) {
                                  return Align(
                                    alignment: Alignment(
                                      (_pulseController.value * 2.5) - 1.25,
                                      0,
                                    ),
                                    child: Container(
                                      width: 50,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            Color(0xFFFFB266),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withOpacity(0.6),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: context.textSecondaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "POWERED BY ADVANCED ATHLETIC SCIENCE",
                                style: TextStyle(
                                  color: context.textSecondaryColor.withOpacity(0.7),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}