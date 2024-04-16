
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../myMap/myMap.dart';
import '../myMap/coordinates_api.dart';
import '../myMap/marker_and_polyline.dart';

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


