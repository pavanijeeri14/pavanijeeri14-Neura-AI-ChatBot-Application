import 'package:flutter/material.dart';
import 'dart:async';

class ChatMessage extends StatefulWidget {
  final String text;
  final bool isUser;
  final bool isTyping;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isTyping = false,
    Key? key,
  }) : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  String animatedText = "";
  int index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isTyping) {
      animatedText = "";
    } else if (widget.isUser) {
      animatedText = widget.text;
    } else {
      _startTypingEffect();
    }
  }

  void _startTypingEffect() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (index < widget.text.length) {
        setState(() {
          animatedText = widget.text.substring(0, index + 1);
          index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isUser ? Color.fromARGB(177, 173, 116, 234) : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black26, width: 1),
        ),
        child: widget.isTyping
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Typing",
                    style: TextStyle(
                      color: widget.isUser ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5),
                  AnimatedDots(),
                ],
              )
            : Text(
                animatedText,
                style: TextStyle(
                  color: widget.isUser ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}

class AnimatedDots extends StatefulWidget {
  @override
  _AnimatedDotsState createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this)..repeat();
    _dotCount = IntTween(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotCount,
      builder: (context, child) {
        return Text(
          "." * (_dotCount.value + 1),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
