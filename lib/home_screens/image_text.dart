import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart'; // Import for clipboard
import 'package:llama_bot/controllers/image_picker_helper.dart';

class ImageToTextScreen extends StatefulWidget {
  @override
  _ImageToTextScreenState createState() => _ImageToTextScreenState();
}

class _ImageToTextScreenState extends State<ImageToTextScreen> {
  File? _selectedImage;
  String _extractedText = "Text will appear here";

  Future<void> _pickAndExtractText(ImageSource source) async {
    final image = await ImagePickerHelper.pickImage(source);
    if (image != null) {
      setState(() => _selectedImage = image);
      _extractTextFromImage(image);
    }
  }

  Future<void> _extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        _extractedText = recognizedText.text.isNotEmpty ? recognizedText.text : "No text found!";
      });
    } catch (e) {
      setState(() => _extractedText = "Error recognizing text: $e");
    } finally {
      textRecognizer.close();
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _extractedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to clipboard!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image to Text", 
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      //backgroundColor: Color.fromARGB(255, 193, 147, 253),
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 200)
                : Icon(Icons.image, size: 100, color: Colors.grey),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text("Capture Image"),
                  onPressed: () => _pickAndExtractText(ImageSource.camera),
                ),
                SizedBox(width: 10),
                TextButton.icon(
                  icon: Icon(Icons.photo_library),
                  label: Text("Pick from Gallery"),
                  onPressed: () => _pickAndExtractText(ImageSource.gallery),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  _extractedText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.copy),
              label: Text("Copy Text"),
              onPressed: _extractedText != "Text will appear here" ? _copyToClipboard : null,
            ),
          ],
        ),
      ),
    );
  }
}
