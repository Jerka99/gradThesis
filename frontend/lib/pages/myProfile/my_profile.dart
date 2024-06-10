import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  final Function() onReturn;

  const MyProfile({
    super.key,
    required this.onReturn});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          onPressed: () {
            onReturn();
          },
          child: const Text('Return'),
        ),
      );
  }
}
