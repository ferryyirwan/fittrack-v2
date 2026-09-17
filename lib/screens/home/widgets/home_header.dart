import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/app_user.dart';

class HomeHeader extends StatelessWidget {
  final AppUser? user;
  final VoidCallback? onMenuTap;

  const HomeHeader({
    super.key,
    required this.user,
    this.onMenuTap,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning ☀️";
    } else if (hour < 18) {
      return "Good Afternoon 🌤️";
    } else {
      return "Good Evening 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Icon(
                Icons.menu_rounded,
                color: context.textColor,
                size: 24,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: context.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                user?.fullName ?? "User",
                style: context.heading1.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              Text(
                "Ready to crush today's workout? 🔥",
                style: context.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Container(
          width: 62,
          height: 62,
          padding: const EdgeInsets.all(2.5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF922D), Color(0xFFFF6B00)],
            ),
          ),
          child: CircleAvatar(
            backgroundColor: context.cardColor,
            backgroundImage:
                user != null && user!.profileImageUrl.isNotEmpty
                    ? NetworkImage(user!.profileImageUrl)
                    : null,
            child: user == null || user!.profileImageUrl.isEmpty
                ? const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 30,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
