import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final Function(String p1, String p2) onLogin;

  const LoginPage({
    super.key,
    required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            onLogin("aa", "bb");
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
