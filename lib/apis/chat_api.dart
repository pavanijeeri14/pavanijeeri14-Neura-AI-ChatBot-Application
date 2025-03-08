// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class GeminiService {
//   final String apiKey = 'AIzaSyDIPkhmR0cZ5IdIyRCMr-OYve8LavqYDro';
//   final String baseUrl = 'https://api.google.com/gemini/v1/query';  

//   Future<String> getResponse(String userQuery) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $apiKey',
//       },
//       body: json.encode({
//         'query': userQuery,
//       }),
//     );

//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       return data['response'];  
//     } else {
//       throw Exception('Failed to fetch response from Gemini API');
//     }
//   }
// }
