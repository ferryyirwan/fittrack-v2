import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../exercise/exercise_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../schedule/schedule_screen.dart';
import '../favorite/favorite_screen.dart';
import '../timer/timer_screen.dart';
import '../home/widgets/home_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static _MainScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainScreenState>();
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> pages = [
    const HomeScreen(),
    const ExerciseScreen(
      category: "All",
      showBackButton: false,
    ),
    const TimerScreen(
      showBackButton: false,
    ),
    const FavoriteScreen(),
    const ScheduleScreen(),
    const ProfileScreen(),
  ];

  void switchTab(int index) {
    if (index >= 0 && index < pages.length) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: const HomeDrawer(),
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF16161A) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          height: 68,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          indicatorColor: AppColors.primary.withOpacity(0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: isDark ? Colors.white70 : Colors.black87),
              selectedIcon: const Icon(Icons.home_rounded, color: AppColors.primary),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined, color: isDark ? Colors.white70 : Colors.black87),
              selectedIcon: const Icon(Icons.fitness_center_rounded, color: AppColors.primary),
              label: "Exercise",
            ),
            NavigationDestination(
              icon: Icon(Icons.timer_outlined, color: isDark ? Colors.white70 : Colors.black87),
              selectedIcon: const Icon(Icons.timer_rounded, color: AppColors.primary),
              label: "Timer",
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded, color: isDark ? Colors.white70 : Colors.black87),
              selectedIcon: const Icon(Icons.favorite_rounded, color: AppColors.primary),
              label: "Favorites",
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined, color: isDark ? Colors.white70 : Colors.black87),
              selectedIcon: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
              label: "Schedule",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: isDark ? Colors.white70 : Colors.black87),
              selectedIcon: const Icon(Icons.person_rounded, color: AppColors.primary),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}