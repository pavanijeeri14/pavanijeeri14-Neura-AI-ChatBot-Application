import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        IconButton(icon: Image.asset('assets/images/Google.png'), onPressed: () {}),
      ],
    );
  } 
}
