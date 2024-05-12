
import 'package:flutter/material.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/role_handler.dart';
import 'package:redux_example/user_role.dart';

import '../../myMap/map_container.dart';

class HomePage extends StatefulWidget {
  List<Map<Coordinate, String>> addressesList;

  HomePage({super.key, required this.addressesList});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetWithRole(
            role: UserRole.customer,
            widgetName: "Map",
            child: const MapContainer()),
        const SizedBox(height: 10.0,),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Text("From:"),
                  Text("To"),
                ],
              ),
              Text("Drive Duration:"),
              ...widget.addressesList
                  .map((map) => map.values)
                  .expand((values) => values)
                  .map((value) => Text(value.toString())) // Convert value to string
                  .toList(),
            ],
          ),
        )
      ],
    );
  }
}


