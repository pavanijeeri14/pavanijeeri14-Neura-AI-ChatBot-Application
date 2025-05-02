import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TextImageAPI {
  static const String apiKey = "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";
  static const String apiUrl = "https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-2";

  // Generate multiple images
  static Future<List<Uint8List?>> generateImages(String prompt, {int count = 2}) async {
    List<Uint8List?> images = [];

    for (int i = 0; i < count; i++) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"inputs": "$prompt $i"}), // Slight variation per image
      );

      if (response.statusCode == 200) {
        images.add(response.bodyBytes);
      } else {
        print("Failed to generate image: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    }

    return images;
  }
}
