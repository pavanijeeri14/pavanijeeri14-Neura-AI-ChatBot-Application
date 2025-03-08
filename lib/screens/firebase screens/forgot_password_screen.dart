import 'package:flutter/material.dart';
import 'package:llama_bot/services/firebase_auth_service.dart';


class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController emailController = TextEditingController();

  void _resetPassword() async {
    await _authService.resetPassword(emailController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password reset email sent! Check your inbox.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _resetPassword, child: Text("Reset Password")),
          ],
        ),
      ),
    );
  }
}
