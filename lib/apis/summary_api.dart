import 'dart:convert';
import 'package:http/http.dart' as http;

class SummarizationService {
  static const String _apiUrl = "https://api.cohere.ai/v1/summarize";
  static const String _apiKey = "xkC2MoPeRvDG3Ot7OWPUnjYv03836TpOWDQADJwb";  

  static Future<String> summarizeText(String text) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"text": text, "length": "medium"}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["summary"];
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }
}


//1e6348b3112a8a196dc08cd92a3d02083d0cb940- api key

//AIzaSyCL6-Tmo7DSXOa35Nm9bm9iLR-RWVHxqqI - starry api


//AIzaSyBdgpyMVOucBSwTlYWgG_ttRjb0LwLO7IE - gemini api


//xkC2MoPeRvDG3Ot7OWPUnjYv03836TpOWDQADJwb - cohere api
