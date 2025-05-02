import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:llama_bot/apis/summary_api.dart';

class DocSummaryScreen extends StatefulWidget {
  @override
  _DocSummaryScreenState createState() => _DocSummaryScreenState();
}

class _DocSummaryScreenState extends State<DocSummaryScreen> {
  final TextEditingController _textController = TextEditingController();
  String _summary = "";
  bool _isLoading = false;
  bool _isSpeaking = false;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false; // Reset when speech completes
      });
    });
  }
  
  //Api calls
  Future<void> summarize() async {
    if (_textController.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _summary = "";
    });

    try {
      String result = await SummarizationService.summarizeText(_textController.text);
      setState(() {
        _summary = result;
      });
    } catch (e) {
      setState(() {
        _summary = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void copySummary() {
    if (_summary.isNotEmpty) {
      FlutterClipboard.copy(_summary);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Summary copied!")));
    }
  }

  void toggleSpeakSummary() async {
    if (_isSpeaking) {
      await flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      if (_summary.isNotEmpty) {
        setState(() {
          _isSpeaking = true;
        });
        await flutterTts.speak(_summary);
      }
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _isLoading = true;
      });

      try {
        String extractedText = await extractText(file);
        setState(() {
          _textController.text = extractedText;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> extractText(File file) async {
    String filePath = file.path.toLowerCase();
    if (filePath.endsWith('.pdf')) {
      return await extractTextFromPdf(file);
    } else {
      return await extractTextFromImage(file);
    }
  }

  Future<String> extractTextFromPdf(File file) async {
    try {
      final PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());
      String extractedText = PdfTextExtractor(document).extractText();
      document.dispose(); // Free memory
      return extractedText.isNotEmpty ? extractedText : "No text found in PDF.";
    } catch (e) {
      return "Error extracting text from PDF: ${e.toString()}";
    }
  }

  Future<String> extractTextFromImage(File file) async {
    try {
      final inputImage = InputImage.fromFile(file);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();
      return recognizedText.text;
    } catch (e) {
      return "Error extracting text from image: ${e.toString()}";
    }
  }

  @override
  void dispose() {
    flutterTts.stop(); // Stop speech when leaving the page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document Summarizer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter text or upload a file...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickFile,
              child: Text("Upload PDF/Image"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: summarize,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Summarize"),
            ),
            SizedBox(height: 20),
            if (_summary.isNotEmpty) ...[
              Text("Summary:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_summary, textAlign: TextAlign.justify),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: copySummary,
                    icon: Icon(Icons.copy),
                    label: Text("Copy"),
                  ),
                  ElevatedButton.icon(
                    onPressed: toggleSpeakSummary,
                    icon: Icon(_isSpeaking ? Icons.volume_off : Icons.volume_up),
                    label: Text(_isSpeaking ? "Stop" : "Speak"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
