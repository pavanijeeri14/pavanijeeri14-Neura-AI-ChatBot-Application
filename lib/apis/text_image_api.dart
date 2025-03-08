import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

const String HUGGING_FACE_API_URL = "https://api-inference.huggingface.co/models/prompthero/openjourney";
const String HUGGING_FACE_API_KEY = "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";

class TextImageAPI {
  static Future<List<Uint8List>> generateImages(String prompt, int count) async {
    List<Future<Uint8List?>> imageFutures = [];

    for (int i = 0; i < count; i++) {
      int randomSeed = Random().nextInt(100000); // Ensure unique images
      imageFutures.add(_fetchImage(prompt, randomSeed, i));
    }

    List<Uint8List?> imageResults = await Future.wait(imageFutures);
    return imageResults.whereType<Uint8List>().toList(); // Filter out null values
  }

  static Future<Uint8List?> _fetchImage(String prompt, int seed, int index) async {
    try {
      final response = await http.post(
        Uri.parse(HUGGING_FACE_API_URL),
        headers: {
          'Authorization': 'Bearer $HUGGING_FACE_API_KEY',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': "$prompt variation ${index + 1}",
          'parameters': {'seed': seed},
        }),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print("❌ API Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching image: $e");
      return null;
    }
  }
}
