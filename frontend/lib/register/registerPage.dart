import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final Function(String p1, String p2) onRegister;

  const RegisterPage({
    super.key,
    required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          onRegister("aa", "bb");
        },
        child: Text('register'),
      ),
    );
  }
}
