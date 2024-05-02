
import 'package:flutter/material.dart';

import '../../myMap/myMap.dart';

class HomePage extends StatefulWidget {
  final Function() onNavigateToLogin;

  const HomePage({super.key, required this.onNavigateToLogin});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return MyMap();
  }
}


