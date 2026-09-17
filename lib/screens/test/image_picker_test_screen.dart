import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/image_service.dart';

class ImagePickerTestScreen extends StatefulWidget {
  const ImagePickerTestScreen({super.key});

  @override
  State<ImagePickerTestScreen> createState() =>
      _ImagePickerTestScreenState();
}

class _ImagePickerTestScreenState
    extends State<ImagePickerTestScreen> {

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker Test"),
      ),
      body: Center(
        child: image == null
            ? const Text("No Image")
            : Image.file(
          image!,
          width: 250,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final picked =
          await ImageService.instance.pickFromGallery();

          if (picked == null) return;

          setState(() {
            image = picked;
          });

        },
        child: const Icon(Icons.photo),
      ),
    );
  }
}