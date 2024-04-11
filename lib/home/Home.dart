import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../shape/TriangleClipper.dart';

class HomePage extends StatefulWidget {
  final Function() onNavigateToLogin;

  const HomePage({super.key, required this.onNavigateToLogin});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final List<Marker> markers = [];
  final List<Polyline> polylines = [];
  int num = 0;
  String? startPoint;
  String? endPoint;

  void handleTap(TapPosition pos, LatLng latlng) async {
    List<dynamic> coordinates = [];
    List<LatLng> coordinatesMapped = [];
    print("dotenv.env] ${dotenv.env['API_KEY']}");

    if (num == 0) {
      startPoint = "${latlng.longitude}, ${latlng.latitude}";
      print("startPoint $startPoint");
    } else {
      startPoint = endPoint ?? startPoint;
      endPoint = "${latlng.longitude}, ${latlng.latitude}";
    }

    print("abracadabraaa ${startPoint} ${endPoint} latlng $latlng");

    String baseurl =
        "https://api.openrouteservice.org/v2/directions/driving-car";
    if (num > 0) {

      var response = await http.get(Uri.parse
        ("$baseurl?api_key=${dotenv
          .env["API_KEY"]}en&start=$startPoint&end=$endPoint"));
      var data = jsonDecode(response.body);
      coordinates = data["features"][0]["geometry"]["coordinates"];
      // coordinates.forEach((element) {
      //   coordinatesMapped.add(new LatLng(element[1], element[0]));
      // });
      coordinatesMapped =
          coordinates.map((element) => LatLng(element[1], element[0])).toList();
      // print("points $coordinates");
    }
    num++;

    setState(() {
      markers.add(Marker(
          point: coordinates.length > 0
              ? LatLng(coordinates[coordinates.length - 1][1],
                  coordinates[coordinates.length - 1][0])
              : latlng,
          width: 45.0,
          height: 80.0,
          builder: (context) => ClipPath(
                clipper: TriangleClipper(),
                child: Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.topCenter,
                    icon: const Icon(
                      Icons.location_on,
                      size: 45.0,
                      color: Colors.red,
                      shadows: [Shadow(color: Colors.red, blurRadius: 4.0)],
                    ),
                    onPressed: () {
                      print(context);
                    },
                  ),
                ),
              )));
      polylines.add(Polyline(
        strokeWidth: 4,
        points: coordinatesMapped,
        color: Colors.blue,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 400,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2.0)),
            child: FlutterMap(
              options: MapOptions(
                  onTap: (pos, latlng) => handleTap(pos, latlng),
                  center: LatLng(43.508133, 16.440193),
                  zoom: 13,
                  maxZoom: 18),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                PolylineLayer(
                  polylines: polylines,
                ),
                MarkerLayer(markers: markers),

                // RichAttributionWidget(
                //   attributions: [
                //     TextSourceAttribution(
                //       'OpenStreetMap contributors',
                //       onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                //     ),
                //   ],
                // ),
              ],
            )),
        // Form(child: child)
      ],
    );
  }
}
