import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_page_transitions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/user_provider.dart';
import '../../bmi/bmi_screen.dart';
import '../../exercise/exercise_screen.dart';
import '../../main/main_screen.dart';
import '../../profile/options_screen.dart';
import '../../profile/profile_screen.dart';
import '../../schedule/schedule_screen.dart';
import '../../timer/timer_screen.dart';

class HomeDrawer extends StatelessWidget {

  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Drawer(
      backgroundColor: context.isDark ? const Color(0xFF131316) : const Color(0xFFF6F6F9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            /// DRAWER HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF922D), Color(0xFFFF6B00)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF1B1B1F),
                      backgroundImage: user != null && user.profileImageUrl.isNotEmpty
                          ? NetworkImage(user.profileImageUrl)
                          : null,
                      child: user == null || user.profileImageUrl.isEmpty
                          ? const Icon(
                              Icons.person_rounded,
                              color: AppColors.primary,
                              size: 32,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user?.fullName ?? "FitTrack Athlete",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "PREMIUM MEMBER",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// DRAWER MENU ITEMS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.person_rounded,
                    title: "Profile",
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.pop(context);
                      final mainState = MainScreen.of(context);
                      if (mainState != null) {
                        mainState.switchTab(5);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      }
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.fitness_center_rounded,
                    title: "Exercise Library",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(context);
                      final mainState = MainScreen.of(context);
                      if (mainState != null) {
                        mainState.switchTab(1);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExerciseScreen(category: "All"),
                          ),
                        );
                      }
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.calendar_month_rounded,
                    title: "Workout Schedule",
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.pop(context);
                      final mainState = MainScreen.of(context);
                      if (mainState != null) {
                        mainState.switchTab(4);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ScheduleScreen()),
                        );
                      }
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.monitor_weight_rounded,
                    title: "BMI Calculator",
                    color: Colors.tealAccent.shade700,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        AppPageTransitions.slideUp(const BmiScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.timer_rounded,
                    title: "Workout Timer",
                    color: Colors.redAccent,
                    isHighlighted: true,
                    onTap: () {
                      Navigator.pop(context);
                      final mainState = MainScreen.of(context);
                      if (mainState != null) {
                        mainState.switchTab(2);
                      } else {
                        Navigator.push(
                          context,
                          AppPageTransitions.slideUp(const TimerScreen()),
                        );
                      }
                    },
                  ),

                  _buildDrawerItem(
                    context: context,
                    icon: Icons.settings_rounded,
                    title: "Options",
                    color: Colors.purpleAccent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        AppPageTransitions.slide(const OptionsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// DRAWER FOOTER
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Divider(color: context.borderColor),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_rounded,
                        size: 16,
                        color: context.textSecondaryColor,
                      ),

                      const SizedBox(width: 6),
                      Text(
                        "FitTrack V2.0.1 Pro",
                        style: context.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isHighlighted
            ? color.withOpacity(0.12)
            : context.isDark
                ? Colors.white.withOpacity(0.03)
                : Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? color.withOpacity(0.4) : Colors.transparent,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: context.heading3.copyWith(
            fontSize: 15,
            color: isHighlighted ? color : context.textColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: isHighlighted ? color : context.textSecondaryColor,
        ),
      ),
    );
  }
}
