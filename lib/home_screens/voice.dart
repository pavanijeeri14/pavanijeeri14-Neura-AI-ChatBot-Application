import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const VoiceScreenApp());
}

class VoiceScreenApp extends StatelessWidget {
  const VoiceScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, 
      home: const VoiceScreen(),
    );
  }
}

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  _VoiceScreenState createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _text = "Tap the mic and start speaking...";
  bool _isTalking = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _isTalking = true;
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
        onSoundLevelChange: (level) {
          setState(() {
            _isTalking = level > 0;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
      _isTalking = false;
    });
  }

  void _speak() async {
    await _flutterTts.speak(_text);
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Text copied to clipboard!",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _clearText() {
    setState(() {
      _text = "Tap the mic and start speaking...";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Speech to Text", 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        //backgroundColor: Color.fromARGB(255, 193, 147, 253),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: _isListening ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: primaryColor.withOpacity(0.2),
                child: IconButton(
                  icon: Icon(
                    _isTalking ? Icons.mic : Icons.mic_off,
                    size: 40,
                    color: primaryColor,
                  ),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: theme.shadowColor,
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
              ),
              child: Text(
                _text,
                style: TextStyle(fontSize: 18, color: theme.textTheme.bodyLarge?.color),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.copy, color: theme.colorScheme.secondary),
                  onPressed: _copyToClipboard,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _clearText,
                ),
              ],
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.volume_up, size: 40, color: primaryColor),
              onPressed: _speak,
            ),
          ],
        ),
      ),
    );
  }
}

