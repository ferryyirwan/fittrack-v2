import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageService {
  ImageService._();

  static final ImageService instance = ImageService._();

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return null;

    return File(image.path);
  }

  Future<File?> takePhoto() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return null;

    return File(image.path);
  }
}