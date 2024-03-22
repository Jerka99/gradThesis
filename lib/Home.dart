import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onNavigateToLogin;

  const HomePage({Key? key, required this.onNavigateToLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            onNavigateToLogin();
          },
          child: Text('Go to Login'),
        ),
      ),
    );
  }
}
