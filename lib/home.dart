import 'package:flutter/material.dart';
import 'package:llama_bot/home_screens/image_text.dart';
import 'package:llama_bot/home_screens/text_image.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:llama_bot/widgets/theme_provider.dart';
import 'package:llama_bot/home_screens/chat_bot.dart';
import 'package:llama_bot/home_screens/doc_summ.dart';
import 'package:llama_bot/home_screens/translator.dart';
import 'package:llama_bot/home_screens/voice.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: const Color.fromARGB(230, 193, 148, 255),
        backgroundColor: Colors.deepPurple,
        title: Text("AI Assistant" ,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode , color: Colors.white,),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          )
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( 
          child: Column(
            children: [
              buildModuleCard(context, "Conversational Bot", "assets/lottie/bot.json", ChatBotPage()),
              buildModuleCard(context, "Text-to-Image", "assets/lottie/image.json", TextToImage()),
              buildModuleCard(context, "Translator", "assets/lottie/translator.json", TranslatorScreen()),
              buildModuleCard(context, "Voice Interaction", "assets/lottie/voice.json", VoiceScreen()),
              buildModuleCard(context, "Image-to-Text", "assets/lottie/text_extract.json", ImageToTextScreen()),
              buildModuleCard(context, "Document Summarization", "assets/lottie/docment.json", DocSummaryScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildModuleCard(BuildContext context, String title, String lottiePath, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        padding: EdgeInsets.all(16),
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 235, 173, 252),
              blurRadius: 3,
              spreadRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Lottie.asset(lottiePath, width: 100, height: 100),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
