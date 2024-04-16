
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'coordinates_api.dart';
import 'marker_and_polyline.dart';

class HomePage extends StatefulWidget {
  final Function() onNavigateToLogin;

  const HomePage({super.key, required this.onNavigateToLogin});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String? startPoint;
  String? endPoint;
  List<LatLng> markerCoordinateList = [];
  List<List<LatLng>> polylinesList = [];

  void handleTap(TapPosition pos, LatLng latlng) async {
    var response;
    List<LatLng> coordinatesMapped = [];

    if (markerCoordinateList.length == 0) {
      startPoint = "${latlng.longitude}, ${latlng.latitude}";
    } else {
      startPoint = endPoint ?? startPoint;
      endPoint = "${latlng.longitude}, ${latlng.latitude}";

      response = await handleCoordinatesCall(startPoint, endPoint);
      coordinatesMapped = response.map<LatLng>((element) => LatLng(element[1],
          element[0])).toList();
    }

    setState(() {
      markerCoordinateList.isEmpty ? markerCoordinateList.add(latlng) :
      markerCoordinateList.add(coordinatesMapped[coordinatesMapped.length-1]);
    });
    setState(() {
      if(coordinatesMapped.length > 1) {
            polylinesList.add(coordinatesMapped);
      }
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
                  maxZoom: 18,
                  minZoom: 1
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                PolylineLayer(
                  polylines: polylinesList.map((points) =>
                  polylineFun(points)
                  ).toList(),
                ),
                MarkerLayer(
                    markers: markerCoordinateList.asMap().entries.map((markerCoordinate) =>
                        markerDisplayFun(
                          markerCoordinate.value,
                          markerCoordinate.key,
                            markerCoordinateList.length,
                          (){
                              setState(() {
                                markerCoordinateList.removeAt(markerCoordinate.key);
                                if(polylinesList.length > 0) {
                                  polylinesList
                                      .removeAt(polylinesList.length - 1);
                                  endPoint = "${markerCoordinateList[markerCoordinateList
                                      .length -1].longitude}, ${markerCoordinateList[markerCoordinateList
                                      .length -1].latitude}";
                              }
                                if(markerCoordinateList.length == 0) {
                                      endPoint = null;
                                    }
                              });
                            }
                        )).toList()),

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
