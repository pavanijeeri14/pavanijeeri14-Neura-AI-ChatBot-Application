import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(AIChatApp());
}

class AIChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neura AI Chat', 
      theme: ThemeData.dark(),
      home: ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isUser ? const Color.fromARGB(255, 179, 132, 250) : const Color.fromARGB(255, 212, 195, 255),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool isLoading = false;

  // Gemini API Key
  final String apiKey = 'AIzaSyDIPkhmR0cZ5IdIyRCMr-OYve8LavqYDro'; 
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  // Send user message
  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userQuery = _controller.text;

    setState(() {
      _messages.insert(0, ChatMessage(text: userQuery, isUser: true));
      isLoading = true;
    });

    _controller.clear();
    await _getGeminiResponse(userQuery);
  }

  // Fetch AI response
  Future<void> _getGeminiResponse(String userQuery) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': userQuery}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String botResponse = data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response received';

        setState(() {
          _messages.insert(0, ChatMessage(text: botResponse, isUser: false));
          isLoading = false;
        });
      } else {
        setState(() {
          _messages.insert(0, ChatMessage(text: 'Error: API response failed!', isUser: false));
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.insert(0, ChatMessage(text: 'Error: $e', isUser: false));
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Neura AI Chat",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          if (isLoading) CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: const Color.fromARGB(255, 249, 249, 249),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: const Color.fromARGB(255, 142, 33, 243)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
