import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(TranslatorApp());
} 

class TranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TranslatorScreen(),
    );
  }
}

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _translatedController = TextEditingController();
  final GoogleTranslator translator = GoogleTranslator();
  String _fromLanguage = 'English';
  String _toLanguage = 'Automatic';

  final Map<String, String> languageMap = {
    'Automatic': 'auto',
    'Afrikaans': 'af',
    'Albanian': 'sq',
    'Amharic': 'am',
    'Arabic': 'ar',
    'Armenian': 'hy',
    'Assamese': 'as',
    'Aymara': 'ay',
    'Azerbaijani': 'az',
    'Bambara': 'bm',
    'Basque': 'eu',
    'Belarusian': 'be',
    'Bengali': 'bn',
    'Bhojpuri': 'bho',
    'Bosnian': 'bs',
    'Bulgarian': 'bg',
    'Catalan': 'ca',
    'Cebuano': 'ceb',
    'Chinese (Simplified)': 'zh-cn',
    'Chinese (Traditional)': 'zh-tw',
    'Corsican': 'co',
    'Croatian': 'hr',
    'Czech': 'cs',
    'Danish': 'da',
    'Dhivehi': 'dv',
    'Dogri': 'doi',
    'Dutch': 'nl',
    'English': 'en',
    'Esperanto': 'eo',
    'Estonian': 'et',
    'Ewe': 'ee',
    'Filipino (Tagalog)': 'tl',
    'Finnish': 'fi',
    'French': 'fr',
    'Frisian': 'fy',
    'Galician': 'gl',
    'Georgian': 'ka',
    'German': 'de',
    'Greek': 'el',
    'Guarani': 'gn',
    'Gujarati': 'gu',
    'Haitian Creole': 'ht',
    'Hausa': 'ha',
    'Hawaiian': 'haw',
    'Hebrew': 'iw',
    'Hindi': 'hi',
    'Hmong': 'hmn',
    'Hungarian': 'hu',
    'Icelandic': 'is',
    'Igbo': 'ig',
    'Indonesian': 'id',
    'Irish': 'ga',
    'Italian': 'it',
    'Japanese': 'ja',
    'Javanese': 'jw',
    'Kannada': 'kn',
    'Kazakh': 'kk',
    'Khmer': 'km',
    'Kinyarwanda': 'rw',
    'Korean': 'ko',
    'Kurdish': 'ku',
    'Kyrgyz': 'ky',
    'Lao': 'lo',
    'Latin': 'la',
    'Latvian': 'lv',
    'Lithuanian': 'lt',
    'Luganda': 'lg',
    'Luxembourgish': 'lb',
    'Macedonian': 'mk',
    'Malay': 'ms',
    'Malayalam': 'ml',
    'Maltese': 'mt',
    'Maori': 'mi',
    'Marathi': 'mr',
    'Mongolian': 'mn',
    'Myanmar (Burmese)': 'my',
    'Nepali': 'ne',
    'Norwegian': 'no',
    'Odia (Oriya)': 'or',
    'Pashto': 'ps',
    'Persian': 'fa',
    'Polish': 'pl',
    'Portuguese': 'pt',
    'Punjabi': 'pa',
    'Romanian': 'ro',
    'Russian': 'ru',
    'Samoan': 'sm',
    'Sanskrit': 'sa',
    'Serbian': 'sr',
    'Sindhi': 'sd',
    'Sinhala': 'si',
    'Slovak': 'sk',
    'Slovenian': 'sl',
    'Somali': 'so',
    'Spanish': 'es',
    'Swahili': 'sw',
    'Swedish': 'sv',
    'Tamil': 'ta',
    'Telugu': 'te',
    'Thai': 'th',
    'Turkish': 'tr',
    'Ukrainian': 'uk',
    'Urdu': 'ur',
    'Uzbek': 'uz',
    'Vietnamese': 'vi',
    'Welsh': 'cy',
    'Yoruba': 'yo',
    'Zulu': 'zu',
  };

  void _translateText() async {
    if (_textController.text.isNotEmpty) {
      var translation = await translator.translate(
        _textController.text,
        from: languageMap[_fromLanguage]!,
        to: languageMap[_toLanguage]!,
      );
      setState(() {
        _translatedController.text = translation.text;
      });
    }
  }

  void _swapLanguages() {
    setState(() {
      String temp = _fromLanguage;
      _fromLanguage = _toLanguage;
      _toLanguage = temp;
      _textController.text = _translatedController.text;
      _translatedController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multilingual Translate' ,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        //backgroundColor: Color.fromARGB(255, 193, 147, 253),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 201, 172, 252), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _fromLanguage,
                      underline: SizedBox(),
                      isExpanded: true,
                      items: languageMap.keys.map((String lang) {
                        return DropdownMenuItem<String>(
                          value: lang,
                          child: Text(lang, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _fromLanguage = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz, size: 28, color: Colors.deepPurple),
                  onPressed: _swapLanguages,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 201, 172, 255), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _toLanguage,
                      underline: SizedBox(),
                      isExpanded: true,
                      items: languageMap.keys.map((String lang) {
                        return DropdownMenuItem<String>(
                          value: lang,
                          child: Text(lang, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _toLanguage = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate', 
              style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                //backgroundColor: const Color.fromARGB(255, 210, 154, 253)
                backgroundColor: Colors.deepPurple, 
                 ), 
            ),
            SizedBox(height: 20),
            TextField(
              controller: _translatedController,
              decoration: InputDecoration(
                labelText: 'Translated text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
