import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/common/primary_button.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onLogout;

  const ActionButtons({
    super.key,
    required this.onEdit,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        PrimaryButton(
          text: "Edit Profile",
          icon: Icons.edit_rounded,
          onPressed: onEdit,
        ),

        const SizedBox(height: AppSpacing.lg),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.error,
            ),
            label: const Text(
              "Logout",
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),

      ],
    );
  }
}