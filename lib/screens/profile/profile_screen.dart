import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/glass_card.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/primary_button.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/cloudinary_service.dart';
import '../../services/image_service.dart';
import '../../services/user_service.dart';

import 'edit_profile_screen.dart';
import 'options_screen.dart';
import 'widgets/bmi_card.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? selectedImage;

  Future<void> _uploadProfileImage(File image) async {
    setState(() {
      selectedImage = image;
    });

    final imageUrl =
        await CloudinaryService.instance.uploadImage(image);

    if (imageUrl == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to upload image."),
        ),
      );
      return;
    }

    await UserService.instance.updateProfileImage(imageUrl);

    if (!mounted) return;

    await context.read<UserProvider>().loadUser();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile picture updated!"),
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    final image = await ImageService.instance.pickFromGallery();

    if (image == null) return;

    await _uploadProfileImage(image);
  }

  Future<void> _takePhoto() async {
    final image = await ImageService.instance.takePhoto();

    if (image == null) return;

    await _uploadProfileImage(image);
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Change Profile Picture",
                  style: context.heading3,
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: Icon(Icons.camera_alt, color: AppColors.primary),
                  title: Text("Take Photo", style: context.bodyLarge),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    await _takePhoto();
                  },
                ),

                ListTile(
                  leading: Icon(Icons.photo_library, color: AppColors.primary),
                  title: Text("Choose from Gallery", style: context.bodyLarge),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    await _pickProfileImage();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.close, color: Colors.grey),
                  title: Text("Cancel", style: context.bodyLarge),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final themeProvider = context.watch<ThemeProvider>();
    final isLightMode = !themeProvider.isDarkMode;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP: GRADIENT BOX (Avatar, Name, Keep pushing limits, horizontal Height/Weight/BMI)
                ProfileHeader(
                  user: user,
                  selectedImage: selectedImage,
                  onAvatarTap: _showImagePickerSheet,
                ),

                const SizedBox(height: 24),

                /// BELOW GRADIENT BOX: EDIT PROFILE BUTTON
                PrimaryButton(
                  text: "Edit Profile",
                  icon: Icons.edit_rounded,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// BELOW EDIT PROFILE: LIGHT THEME OPTION WITH TOGGLE SWITCH
                GlassCard(
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isLightMode
                              ? Colors.amber.withOpacity(0.2)
                              : AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isLightMode
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: isLightMode
                              ? Colors.amber.shade700
                              : AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Light Theme",
                              style: context.heading3.copyWith(fontSize: 17),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isLightMode
                                  ? "Bright appearance active"
                                  : "Switch to light appearance",
                              style: context.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isLightMode,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// BELOW LIGHT THEME: OPTIONS (ABOUT V2.0.1 & LOGOUT)
                GlassCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OptionsScreen(),
                      ),
                    );
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.secondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Options & Settings",
                              style: context.heading3.copyWith(fontSize: 17),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "About FitTrack V2.0.1 & Logout",
                              style: context.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: context.textSecondaryColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  "Additional Health Stats",
                  style: context.heading3.copyWith(fontSize: 18),
                ),

                const SizedBox(height: 16),

                ProfileStats(
                  user: user,
                ),

                const SizedBox(height: 16),

                BmiCard(
                  user: user,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}