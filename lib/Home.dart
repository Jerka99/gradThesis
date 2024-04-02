import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final Function () onNavigateToLogin;

  const HomePage({
    super.key,
    required this.onNavigateToLogin
  });

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
