import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class AvatarWidget extends StatelessWidget {
  final File? selectedImage;
  final String imageUrl;
  final VoidCallback onTap;

  const AvatarWidget({
    super.key,
    required this.selectedImage,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (selectedImage != null) {
      imageProvider = FileImage(selectedImage!);
    } else if (imageUrl.isNotEmpty) {
      imageProvider = NetworkImage(imageUrl);
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [

          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? const Icon(
                Icons.person,
                size: 55,
              )
                  : null,
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),

        ],
      ),
    );
  }
}