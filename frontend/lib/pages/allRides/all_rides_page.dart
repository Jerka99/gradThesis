import 'package:flutter/material.dart';

class AllRidesPage extends StatelessWidget {
  final Function(String p1, String p2) onSomething;

  const AllRidesPage({
    super.key,
    required this.onSomething});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          onSomething("aa", "bb");
        },
        child: const Text('Logout'),
      ),
    );
  }
}
