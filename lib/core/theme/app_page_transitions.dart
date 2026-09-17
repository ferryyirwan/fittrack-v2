import 'package:flutter/material.dart';

class AppPageTransitions {
  AppPageTransitions._();

  static PageRouteBuilder<T> slide<T>(Widget page, {Duration duration = const Duration(milliseconds: 360)}) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final secondaryCurvedAnimation = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(curvedAnimation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-0.04, 0.0),
                ).animate(secondaryCurvedAnimation),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  static PageRouteBuilder<T> slideUp<T>(Widget page, {Duration duration = const Duration(milliseconds: 380)}) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
          reverseCurve: Curves.easeInQuart,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.14),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1.0).animate(curvedAnimation),
              child: child,
            ),
          ),
        );
      },
    );
  }

  static PageRouteBuilder<T> zoom<T>(Widget page, {Duration duration = const Duration(milliseconds: 350)}) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}

class SmoothPageTransitionsBuilder extends PageTransitionsBuilder {
  const SmoothPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child;
    }

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final secondaryCurvedAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.07, 0.0),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.985, end: 1.0).animate(curvedAnimation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.035, 0.0),
            ).animate(secondaryCurvedAnimation),
            child: child,
          ),
        ),
      ),
    );
  }
}
