import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:llama_bot/controllers/chat_message.dart';


class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    await FirebaseFirestore.instance.collection('chats').add({
      'text': text,
      'isUser': true,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();

    // Show typing indicator
    setState(() => _isTyping = true);
    final typingDoc = await FirebaseFirestore.instance.collection('chats').add({
      'text': '',
      'isUser': false,
      'timestamp': FieldValue.serverTimestamp(),
      'isTyping': true,
    });

    // Simulate delay and AI response
    await Future.delayed(Duration(seconds: 2)); // Replace with actual API call

    // Delete typing indicator
    await FirebaseFirestore.instance.collection('chats').doc(typingDoc.id).delete();

    // Add AI response
    await FirebaseFirestore.instance.collection('chats').add({
      'text': 'Hello, I am your AI assistant!',
      'isUser': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() => _isTyping = false);
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    return ChatMessage(
      text: message['text'] ?? '',
      isUser: message['isUser'] ?? false,
      isTyping: message['isTyping'] ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Neura AI Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    return _buildMessage(data);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask something...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
