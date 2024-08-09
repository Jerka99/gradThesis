import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/user_role.dart';

import 'marker_and_polyline.dart';

class MyMap extends StatefulWidget {
  final List<LatLng> markerCoordinateList;
  final List<List<LatLng>> polylineList;
  final Function()? saveMapData;
  final Function(int)? removeLastMarkerFun;
  final Function(LatLng)? addMapData;
  final UserRole? userRole;
  final bool enableScrollWheel;
  final LatLng? currentUserLocation;

  const MyMap({
    super.key,
    required this.markerCoordinateList,
    required this.polylineList,
    this.saveMapData,
    this.addMapData,
    this.removeLastMarkerFun,
    this.userRole,
    this.enableScrollWheel = false,
    required this.currentUserLocation,
  });

  @override
  State<MyMap> createState() => _MyMap();
}

class _MyMap extends State<MyMap> {
  late bool enableScrollWheel;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    enableScrollWheel = widget.enableScrollWheel;
  }

  @override
  void didUpdateWidget(MyMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentUserLocation != oldWidget.currentUserLocation) {
        _mapController.move(widget.currentUserLocation!, 13.0);
    }
  }


  @override
  Widget build(BuildContext context) {
    List<LatLng> markerCoordinateList = widget.markerCoordinateList;
    List<List<LatLng>> polylineList = widget.polylineList;

    return Column(
      children: [
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0)),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  enableScrollWheel: enableScrollWheel,
                    onTap: (pos, latLng) {
                      if (widget.addMapData != null) {
                        widget.addMapData!(latLng);
                      }
                      setState(() {
                        enableScrollWheel = true;
                      });
                    },
                    center: widget.currentUserLocation,
                    zoom: 13,
                    maxZoom: 18,
                    minZoom: 1,
                    interactiveFlags:
                        InteractiveFlag.pinchZoom | InteractiveFlag.drag),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                                  if (widget.removeLastMarkerFun != null) {
                                    widget.removeLastMarkerFun!(
                                        markerCoordinate.key);
                                  }
                                } else {
                                  // widget.chooseTwoStations();
                                  // print(markerCoordinate);
                                }
                              }))
                          .toList()),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: FloatingActionButton(
                              backgroundColor: Colors.blue,
                              onPressed: () {
                                  widget.saveMapData!();
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))))
                ],
              )),
        ),
      ],
    );
  }
}
