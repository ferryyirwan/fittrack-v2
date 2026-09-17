import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/app_user.dart';
import 'avatar_widget.dart';

class ProfileHeader extends StatelessWidget {
  final AppUser? user;
  final File? selectedImage;
  final VoidCallback onAvatarTap;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.selectedImage,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF922D),
            Color(0xFFFF6B00),
            Color(0xFFE65100),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 85,
                height: 85,
                child: FittedBox(
                  child: AvatarWidget(
                    selectedImage: selectedImage,
                    imageUrl: user?.profileImageUrl ?? "",
                    onTap: onAvatarTap,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.fullName.isNotEmpty == true
                          ? user!.fullName
                          : "User",
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Keep pushing your limits!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (user?.workoutStreak != null && user!.workoutStreak > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${user!.workoutStreak} Days Streak 🔥",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.16),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  title: "HEIGHT",
                  value: "${user?.height.toInt() ?? 0} cm",
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatColumn(
                  title: "WEIGHT",
                  value: "${user?.weight.toInt() ?? 0} kg",
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatColumn(
                  title: "BMI",
                  value: user != null && user!.bmi > 0
                      ? user!.bmi.toStringAsFixed(1)
                      : "-",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({required String title, required String value}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}