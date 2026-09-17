import 'dart:convert';

import 'package:http/http.dart' as http;

class FitnessTipService {
  FitnessTipService._();

  static final FitnessTipService instance = FitnessTipService._();

  Future<String> getDailyTip() async {
    try {
      final response = await http.get(
        Uri.parse("https://zenquotes.io/api/random"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return "${data[0]["q"]}\n\n— ${data[0]["a"]}";
      }

      return "Stay consistent. Small progress is still progress.";
    } catch (_) {
      return "Stay consistent. Small progress is still progress.";
    }
  }
}