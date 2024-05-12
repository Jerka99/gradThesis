import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

import 'coordinates_api.dart';
import 'marker_and_polyline.dart';

class MyMap extends StatefulWidget {
  final Function(LatLng, List<LatLng>) addMarkerAndPolyFun;
  final Function(Geocoding) addAddress;
  final Function(int) removeLastMarkerFun;
  final List<LatLng> markerCoordinateList;
  final List<List<LatLng>> polylineList;
  final List<Map<Coordinate, String>> addressesList;

  const MyMap({
    super.key,
    required this.addMarkerAndPolyFun,
    required this.addAddress,
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

  void handleAddresses(endPoint) async {
    await handleAddressName(
        endPoint, (addressResponse) => widget.addAddress(addressResponse));
  }

  void handleTap(TapPosition pos, LatLng latlng) async {
    if (!loading) {
      List? response;
      List<LatLng> coordinatesMapped = [];

      if (widget.markerCoordinateList.isEmpty) {
        startPoint = "${latlng.longitude}, ${latlng.latitude}";
        endPoint = startPoint;
      } else {
        LatLng lastMarker =
            widget.markerCoordinateList[widget.markerCoordinateList.length - 1];
        tempStartPoint =
            startPoint; //no wrong polylines if we re clicking on the sea
        tempEndPoint = endPoint;
        startPoint = "${lastMarker.longitude}, ${lastMarker.latitude}"; //?? startPoint
        endPoint = "${latlng.longitude}, ${latlng.latitude}";
      }
      handleAddresses(endPoint);
      response = await handleCoordinatesCall(
          startPoint, endPoint, (bool value) => {loading = value});

      if (response!.isNotEmpty) {
        coordinatesMapped = response
            .map<LatLng>((element) => LatLng(element[1], element[0]))
            .toList();
        widget.addMarkerAndPolyFun(
            coordinatesMapped[coordinatesMapped.length - 1], coordinatesMapped);
      } else {
        startPoint = tempStartPoint;
        endPoint = tempEndPoint;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> markerCoordinateList = widget.markerCoordinateList;
    List<List<LatLng>> polylineList = widget.polylineList;
    List<Map<Coordinate, String>> addressesList = widget.addressesList;

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
                                // else {
                                //   Future.delayed(const Duration(seconds: 1),
                                //       () {
                                //     deleteFun();
                                //   });
                                // }
                              }
                              // setState(() {
                              //   print(markerCoordinateList.length);
                              //   if (markerCoordinateList.length - 1 ==
                              //       markerCoordinate.key) {
                              //     markerCoordinateList
                              //         .removeAt(markerCoordinate.key);
                              //
                              //     if (polylineList.isNotEmpty) {
                              //       print("duljinaa ${polylineList.length}");
                              //       polylineList
                              //           .removeAt(polylineList.length - 1);
                              //       endPoint =
                              //           "${markerCoordinateList[markerCoordinateList.length - 1].longitude}, ${markerCoordinateList[markerCoordinateList.length - 1].latitude}";
                              //     }
                              //   }
                              // });
                            }))
                        .toList()),
              ],
            )),
      ],
    );
  }
}
