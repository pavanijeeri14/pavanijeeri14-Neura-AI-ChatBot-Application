import 'package:flutter/material.dart';
import 'package:llama_bot/home.dart';
//import 'package:llama_bot/screens/firebase%20screens/welcome_screen.dart';
//import 'package:llama_bot/screens/firebase%20screens/register_screen.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0; 
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 230, 230),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                OnboardingPage(
                  animation: 'assets/lottie/ai.json',
                  title: 'AI assistant',
                  description: 'Llama 3 is a powerful AI model for various tasks.',
                ),
                OnboardingPage(
                  animation: 'assets/lottie/animate2.json',
                  title: 'AI Chatbot',
                  description: 'An interactive AI chatbot for seamless conversations.',
                ),
              ],
            ),
          ),

          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: _currentIndex == index ? 12 : 8,
                height: _currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),

          // Next Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (_currentIndex == 1) {
                  // Go to next screen
                  Navigator.pushReplacement(
                    context,
                    //MaterialPageRoute(builder: (context) => RegisterScreen()), WelcomeScreen
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  // Move to next page with smooth transition
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                
                
                elevation: 5,
              ),
              child: Text(
                _currentIndex == 1 ? "Get Started" : "Next",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox( height: 80,)
        ],
      ),
    );
  }
}


// Reusable Onboarding Page Widget
class OnboardingPage extends StatelessWidget {
  final String animation;
  final String title;
  final String description;

  OnboardingPage({required this.animation, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          animation,
          width: 250,
          height: 250,
          repeat: true,
          reverse: true,
          animate: true,
          frameRate: FrameRate(60),
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
