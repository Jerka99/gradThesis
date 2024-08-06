import 'package:flutter/material.dart';

class AllRidesPage extends StatefulWidget {
  Function fetchAllRides;

  AllRidesPage({
    required this.fetchAllRides,
    super.key});

  @override
  State<AllRidesPage> createState() => _AllRidesPageState();
}

class _AllRidesPageState extends State<AllRidesPage> {

  @override
  void initState() {
    super.initState();
    widget.fetchAllRides();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
        },
        child: const Text('nothing'),
      ),
    );
  }
}
