import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:llama_bot/firebase_options.dart';
import 'package:llama_bot/widgets/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:llama_bot/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}


// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:llama_bot/widgets/theme_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:llama_bot/screens/splash_screen.dart';
// import 'firebase_options.dart'; // 🔹 Ensure this is imported

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform, // 🔹 Ensure firebase_options.dart is generated
//     );
//     print("✅ Firebase initialized successfully!");
//   } catch (e) {
//     print("❌ Firebase initialization failed: $e");
//   }

//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: themeProvider.themeMode,
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       home: SplashScreen(),
//     );
//   }
// }
