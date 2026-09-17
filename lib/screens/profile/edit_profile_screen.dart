import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/custom_back_button.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/primary_button.dart';
import '../../models/app_user.dart';
import '../../providers/user_provider.dart';
import '../../services/cloudinary_service.dart';
import '../../services/image_service.dart';
import '../../services/user_service.dart';
import '../auth/widgets/auth_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _loaded = false;
  bool _isSaving = false;
  bool _isUploadingImage = false;
  File? _selectedImage;

  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  String gender = "Male";
  DateTime? selectedDate;

  String _formatDate(DateTime d) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return "${d.day} ${months[d.month - 1]} ${d.year}";
  }

  @override
  void dispose() {
    nameController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Theme.of(context).brightness,
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    setState(() {
      _selectedImage = image;
      _isUploadingImage = true;
    });

    final imageUrl = await CloudinaryService.instance.uploadImage(image);

    if (imageUrl == null) {
      if (!mounted) return;
      setState(() {
        _isUploadingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to upload image. Please try again."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await UserService.instance.updateProfileImage(imageUrl);

    if (!mounted) return;
    await context.read<UserProvider>().loadUser();

    setState(() {
      _isUploadingImage = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text("Profile picture updated successfully!", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Change Profile Picture",
                  style: context.heading3.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 22),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                  ),
                  title: Text("Take Photo", style: context.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    await _takePhoto();
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: Colors.blueAccent),
                  ),
                  title: Text("Choose from Gallery", style: context.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    await _pickProfileImage();
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  double? _calculateLiveBmi() {
    final h = double.tryParse(heightController.text) ?? 0;
    final w = double.tryParse(weightController.text) ?? 0;
    if (h <= 0 || w <= 0) return null;
    return w / ((h / 100) * (h / 100));
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return "Underweight 🥶";
    if (bmi < 25.0) return "Normal Weight 💪";
    if (bmi < 30.0) return "Overweight 🏃";
    return "Obese ❤️";
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blueAccent;
    if (bmi < 25.0) return Colors.green;
    if (bmi < 30.0) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final isDark = context.isDark;

    if (!_loaded && user != null) {
      nameController.text = user.fullName;
      heightController.text = user.height == 0 ? "" : user.height.toString();
      weightController.text = user.weight == 0 ? "" : user.weight.toString();
      gender = user.gender.isEmpty ? "Male" : user.gender;
      selectedDate = user.dateOfBirth;
      _loaded = true;
    }

    final liveBmi = _calculateLiveBmi();

    ImageProvider? avatarProvider;
    if (_selectedImage != null) {
      avatarProvider = FileImage(_selectedImage!);
    } else if (user?.profileImageUrl != null && user!.profileImageUrl.isNotEmpty) {
      avatarProvider = NetworkImage(user.profileImageUrl);
    }

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Navigation & Title Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    Text(
                      "Edit Profile",
                      style: context.heading2.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 44), // balance back button width
                  ],
                ),

                const SizedBox(height: 28),

                // 1. Glowing Avatar Header Card with Live Photo Upload
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _showImagePickerSheet,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 124,
                              height: 124,
                              padding: const EdgeInsets.all(3.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [AppColors.primary, AppColors.secondary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.35),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.cardColor,
                                ),
                                clipBehavior: Clip.antiAlias,
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  fit: StackFit.expand,
                                  children: [
                                    if (avatarProvider != null)
                                      Image(
                                        image: avatarProvider,
                                        fit: BoxFit.cover,
                                      )
                                    else
                                      Center(
                                        child: Text(
                                          nameController.text.isNotEmpty
                                              ? nameController.text
                                                  .trim()
                                                  .split(' ')
                                                  .map((e) => e.isNotEmpty ? e[0] : '')
                                                  .take(2)
                                                  .join()
                                                  .toUpperCase()
                                              : "FT",
                                          style: context.heading1.copyWith(
                                            fontSize: 36,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    if (_isUploadingImage)
                                      Container(
                                        color: Colors.black.withOpacity(0.6),
                                        child: const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 28,
                                              height: 28,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              "Uploading...",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.cardColor,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.stars_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user?.email ?? "Pro Athlete Member",
                              style: TextStyle(
                                color: context.textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 32),


                // 2. Section: Personal Identity
                Text(
                  "PERSONAL DETAILS",
                  style: context.bodySmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: context.borderColor),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Full Name", style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      AuthTextField(
                        controller: nameController,
                        hintText: "Enter your full name",
                        prefixIcon: Icons.person_rounded,
                        onChanged: (val) => setState(() {}),
                      ),
                      const SizedBox(height: 20),

                      Text("Gender Selection", style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGenderCard(
                              title: "Male",
                              icon: Icons.male_rounded,
                              color: Colors.blueAccent,
                              isSelected: gender == "Male",
                              onTap: () => setState(() => gender = "Male"),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildGenderCard(
                              title: "Female",
                              icon: Icons.female_rounded,
                              color: Colors.pinkAccent,
                              isSelected: gender == "Female",
                              onTap: () => setState(() => gender = "Female"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text("Date of Birth", style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E24) : context.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: context.borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedDate == null
                                          ? "Select Birth Date"
                                          : _formatDate(selectedDate!),
                                      style: context.heading3.copyWith(fontSize: 15),
                                    ),

                                    if (selectedDate != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        "${DateTime.now().year - selectedDate!.year} years old",
                                        style: context.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 3. Section: Body Metrics & Live BMI
                Text(
                  "BODY METRICS & STATS",
                  style: context.bodySmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: context.borderColor),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Height (cm)", style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                AuthTextField(
                                  controller: heightController,
                                  hintText: "170",
                                  prefixIcon: Icons.height_rounded,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) => setState(() {}),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Weight (kg)", style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                AuthTextField(
                                  controller: weightController,
                                  hintText: "65",
                                  prefixIcon: Icons.monitor_weight_rounded,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) => setState(() {}),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (liveBmi != null) ...[
                        const SizedBox(height: 20),
                        Divider(color: context.borderColor),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: _getBmiColor(liveBmi).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _getBmiColor(liveBmi).withOpacity(0.4),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getBmiColor(liveBmi),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Live BMI: ${liveBmi.toStringAsFixed(1)}",
                                      style: context.heading3.copyWith(
                                        fontSize: 16,
                                        color: _getBmiColor(liveBmi),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _getBmiCategory(liveBmi),
                                      style: context.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 38),

                // Save Changes Button with loading state
                PrimaryButton(
                  text: _isSaving ? "Saving Changes..." : "Save Profile Changes",
                  icon: _isSaving ? Icons.sync_rounded : Icons.check_circle_outline_rounded,
                  onPressed: _isSaving
                      ? () {}
                      : () async {
                          setState(() => _isSaving = true);
                          final currentUser = FirebaseAuth.instance.currentUser;

                          if (currentUser == null) {
                            setState(() => _isSaving = false);
                            return;
                          }

                          final oldUser = context.read<UserProvider>().user;
                          if (oldUser == null) {
                            setState(() => _isSaving = false);
                            return;
                          }

                          final updatedUser = AppUser(
                            uid: currentUser.uid,
                            fullName: nameController.text.trim(),
                            email: oldUser.email,
                            gender: gender,
                            dateOfBirth: selectedDate ?? oldUser.dateOfBirth,
                            height: double.tryParse(heightController.text) ?? 0,
                            weight: double.tryParse(weightController.text) ?? 0,
                            profileImageUrl: oldUser.profileImageUrl,
                            workoutStreak: oldUser.workoutStreak,
                            createdAt: oldUser.createdAt,
                          );

                          await UserService.instance.updateUser(updatedUser);
                          await context.read<UserProvider>().loadUser();

                          if (!mounted) return;
                          setState(() => _isSaving = false);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text("Profile updated successfully!", style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );

                          Navigator.pop(context);
                        },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(isDark ? 0.22 : 0.15)
              : (isDark ? const Color(0xFF1E1E24) : context.cardColor),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : context.borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : context.textSecondaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: context.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : context.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}