import 'package:flutter/material.dart';

class Unknown extends StatelessWidget {
  final Function() onReturn;

  const Unknown({
    super.key,
    required this.onReturn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unknown Page 404'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            onReturn();
          },
          child: Text('Return'),
        ),
      ),
    );
  }
}
