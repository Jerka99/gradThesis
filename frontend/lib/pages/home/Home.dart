import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/myMap/map_and_display.dart';
import 'package:travel_mate/user_role.dart';

import '../../myMap/map_and_display_connector.dart';

class HomePage extends StatefulWidget {
  Function() fetchLocation;

  HomePage(
      {super.key,
      required this.fetchLocation,
      });


  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    widget.fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MapAndDisplayConnector();
  }
}
