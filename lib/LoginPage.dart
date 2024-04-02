import 'package:flutter/material.dart';
import 'package:redux_example/globals.dart';

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
            print(routerDelegate);
            onLogin("aa", "bb");
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
