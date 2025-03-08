import 'package:flutter/material.dart';
import 'package:llama_bot/services/firebase_auth_service.dart';
import 'login_screen.dart';

class FireHomeScreen extends StatelessWidget {
  final FirebaseAuthService _authService = FirebaseAuthService();

  void _logout(BuildContext context) async {
    await _authService.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), actions: [
        IconButton(icon: Icon(Icons.logout), onPressed: () => _logout(context)),
      ]),
      body: Center(child: Text("Welcome to the App!")),
    );
  }
}
