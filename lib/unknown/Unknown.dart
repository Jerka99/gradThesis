import 'package:flutter/material.dart';

class Unknown extends StatelessWidget {
  final Function() onReturn;

  const Unknown({
    super.key,
    required this.onReturn});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          onPressed: () {
            onReturn();
          },
          child: Text('Return'),
        ),
      );
  }
}
