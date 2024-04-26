import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'coordinates_api.dart';
import 'marker_and_polyline.dart';

class MyMap extends StatefulWidget {

  @override
  State<MyMap> createState() => _MyMap();
}

class _MyMap extends State<MyMap>{
  String? startPoint;
  String? endPoint;
  String? tempStartPoint;
  String? tempEndPoint;
  List<LatLng> markerCoordinateList = [];
  List<List<LatLng>> polylineList = [];
  bool loading = false;


  void handleTap(TapPosition pos, LatLng latlng) async {
    if (!loading) {
      var response;
      List<LatLng> coordinatesMapped = [];

      if (markerCoordinateList.length == 0) {
        startPoint = "${latlng.longitude}, ${latlng.latitude}";
        endPoint = startPoint;
      } else {
        tempStartPoint =
            startPoint; //no wrong polylines if we re clicking on the sea
        tempEndPoint = endPoint;
        startPoint = endPoint; //?? startPoint
        endPoint = "${latlng.longitude}, ${latlng.latitude}";
      }

      response = await handleCoordinatesCall(
          startPoint,
          endPoint,
          (bool value) => {loading = value}
      );
      if (response.length != 0) {
        coordinatesMapped = response
            .map<LatLng>((element) => LatLng(element[1], element[0]))
            .toList();

        setState(() {
          markerCoordinateList
              .add(coordinatesMapped[coordinatesMapped.length - 1]);
        });
        setState(() {
          if (markerCoordinateList.length > 1) {
            polylineList.add(coordinatesMapped);
          }
        });
      }
      else {
        startPoint = tempStartPoint;
        endPoint = tempEndPoint;
      }
    }
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
                  polylines: polylineList.map((points) =>
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
                                if(markerCoordinateList.length-1 ==
                                markerCoordinate.key){
                                markerCoordinateList.removeAt(
                                    markerCoordinate.key);

                                if(polylineList.length > 0) {
                                  polylineList.removeAt(polylineList.length - 1);
                                  endPoint = "${markerCoordinateList[markerCoordinateList
                                      .length -1].longitude}, ${markerCoordinateList[markerCoordinateList
                                      .length -1].latitude}";
                                }}
                              });
                            }
                        )).toList()),
              ],
            )),
      ],
    );
  }
}