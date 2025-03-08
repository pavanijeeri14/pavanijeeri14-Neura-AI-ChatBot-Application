import 'dart:async';

import 'package:flutter/material.dart';
import 'package:llama_bot/screens/onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 232, 210, 252), 
      backgroundColor:Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/ai.png',
          width: 150.0,
          height: 150.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

}
