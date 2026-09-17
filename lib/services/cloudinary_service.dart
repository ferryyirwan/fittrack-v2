import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  CloudinaryService._();

  static final CloudinaryService instance =
  CloudinaryService._();

  static const String cloudName = "ogxvvl7j";

  static const String uploadPreset =
      "fittrack_profile";

  Future<String?> uploadImage(File image) async {

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request =
    http.MultipartRequest("POST", uri);

    request.fields["upload_preset"] =
        uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        image.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {

      final responseData =
      await response.stream.bytesToString();

      final data =
      jsonDecode(responseData);

      return data["secure_url"];

    }

    return null;
  }
}