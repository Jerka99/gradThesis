import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  final Function() logOut;

  const MyProfile({
    super.key,
    required this.logOut});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          onPressed: () {
            logOut();
          },
          child: const Text('Log out'),
        ),
      );
  }
}
