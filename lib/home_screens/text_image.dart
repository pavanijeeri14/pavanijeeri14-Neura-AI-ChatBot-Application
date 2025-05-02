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
  List<Uint8List> imageList = [];
  bool isLoading = false;
  TextEditingController promptController = TextEditingController();

  void generateImages() async {
    if (promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a prompt")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      imageList.clear();
    });

    try {
      List<Uint8List?> generatedImages = await TextImageAPI.generateImages(
        promptController.text,
        count: 2, // You can increase this to generate more
      );
      setState(() {
        imageList = generatedImages.whereType<Uint8List>().toList();
      });
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> shareImage(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/shared_image.png');
      await file.writeAsBytes(imageBytes);
      await Share.shareXFiles([XFile(file.path)], text: "Check out this AI-generated image!");
    } catch (e) {
      print("Error sharing image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to share image")),
      );
    }
  }

  Future<void> saveImage(Uint8List imageBytes) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/generated_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image saved at $filePath")),
      );
    } catch (e) {
      print("Error saving image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save image")),
      );
    }
  }

  void previewImage(Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(imageBytes),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: Icon(Icons.share), onPressed: () => shareImage(imageBytes)),
                IconButton(icon: Icon(Icons.download), onPressed: () => saveImage(imageBytes)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: imageList.isNotEmpty
                        ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: imageList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => previewImage(imageList[index]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(imageList[index], fit: BoxFit.cover),
                                ),
                              );
                            },
                          )
                        : Center(child: Text("No images generated yet")),
                  ),
          ],
        ),
      ),
    );
  }
}
