import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:llama_bot/apis/text_image_api.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TextToImage extends StatefulWidget {
  @override
  _TextToImageState createState() => _TextToImageState();
}

class _TextToImageState extends State<TextToImage> {
  List<Uint8List> imageList = []; // Stores multiple images
  bool isLoading = false;
  TextEditingController promptController = TextEditingController();

  void generateImages() async {
    if (promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a prompt")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      List<Uint8List> generatedImages = await TextImageAPI.generateImages(promptController.text, 10);
      setState(() {
        imageList = generatedImages;
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate images")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void shareImage(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/generated_image.png');
      await file.writeAsBytes(imageBytes);
      await Share.shareXFiles([XFile(file.path)], text: "Generated Image");
    } catch (e) {
      print("Error sharing image: $e");
    }
  }

  Future<void> saveImage(Uint8List imageBytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/generated_image.png';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Image saved at $filePath")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 193, 147, 253),
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Text-to-Image Generator",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: promptController,
              decoration: InputDecoration(
                labelText: "Enter your prompt",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: generateImages,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 193, 147, 253),
                foregroundColor: Colors.white,
              ),
              child: Text("Generate Images"),
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: imageList.isNotEmpty
                        ? ListView.builder(
                            itemCount: imageList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Image.memory(imageList[index]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.share),
                                        onPressed: () => shareImage(imageList[index]),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.download),
                                        onPressed: () => saveImage(imageList[index]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              );
                            },
                          )
                        : Text("No images generated yet"),
                  ),
          ],
        ),
      ),
    );
  }
}
