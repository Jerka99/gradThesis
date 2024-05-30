import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

import 'coordinates_api.dart';
import 'marker_and_polyline.dart';

class MyMap extends StatefulWidget {
  final Function(LatLng, List<LatLng>) addMarkerAndPolyFun;
  final Function(Geocoding) addAddress;
  final Function(LatLng) addMapData;
  final Function(int) removeLastMarkerFun;
  final List<LatLng> markerCoordinateList;
  final List<List<LatLng>> polylineList;
  final List<Map<Coordinate, String>> addressesList;

  const MyMap({
    super.key,
    required this.addMarkerAndPolyFun,
    required this.addAddress,
    required this.addMapData,
    required this.removeLastMarkerFun,
    required this.markerCoordinateList,
    required this.polylineList,
    required this.addressesList,
  });

  @override
  State<MyMap> createState() => _MyMap();
}

class _MyMap extends State<MyMap> {
  String? startPoint;
  String? endPoint;
  String? tempStartPoint;
  String? tempEndPoint;
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    List<LatLng> markerCoordinateList = widget.markerCoordinateList;
    List<List<LatLng>> polylineList = widget.polylineList;

    return Column(
      children: [
        Container(
            height: 400,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2.0)),
            child: FlutterMap(
              options: MapOptions(
                  onTap: (pos, latlng) => widget.addMapData(latlng),
                  center: LatLng(43.508133, 16.440193),
                  zoom: 13,
                  maxZoom: 18,
                  minZoom: 1),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                PolylineLayer(
                  polylines: polylineList
                      .map((points) => polylineFun(points))
                      .toList(),
                ),
                MarkerLayer(
                    markers: markerCoordinateList
                        .asMap()
                        .entries
                        .map((markerCoordinate) => markerDisplayFun(
                                markerCoordinate.value,
                                markerCoordinate.key,
                                markerCoordinateList.length, () {
                              if (markerCoordinateList.length - 1 ==
                                  markerCoordinate.key) {
                                 widget.removeLastMarkerFun(markerCoordinate.key);
                              }
                            }))
                        .toList()),
              ],
            )),
      ],
    );
  }
}
