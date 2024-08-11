import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/user_role.dart';

import 'marker_and_polyline.dart';

class MyMap extends StatefulWidget {
  final List<LatLng>? markerCoordinateList;
  final List<LatLng>? polylineList;
  final Function() saveMapData;
  final UserRole? userRole;
  final bool enableScrollWheel;
  final LatLng? currentUserLocation;
  final Function(LatLng)? addMarker;
  final Function(int index)? removeMarker;

  const MyMap({
    super.key,
    this.markerCoordinateList,
    this.polylineList,
    required this.saveMapData,
    this.userRole,
    this.enableScrollWheel = false,
    required this.currentUserLocation,
    this.addMarker,
    this.removeMarker,
  });

  @override
  State<MyMap> createState() => _MyMap();
}

class _MyMap extends State<MyMap> {
  late bool enableScrollWheel;
  final MapController _mapController = MapController();
  late List<LatLng> markerCoordinateList;
  late List<LatLng> polylineList;

  @override
  void initState() {
    super.initState();
    markerCoordinateList = widget.markerCoordinateList ?? <LatLng>[];
    polylineList = widget.polylineList ?? [];
    enableScrollWheel = widget.enableScrollWheel;
  }

  @override
  void didUpdateWidget(MyMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    markerCoordinateList = widget.markerCoordinateList ?? <LatLng>[];
    polylineList = widget.polylineList ?? [];
    if (widget.currentUserLocation != oldWidget.currentUserLocation) {
        _mapController.move(widget.currentUserLocation!, 13.0);
    }
  }


  @override
  Widget build(BuildContext context) {

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
                      widget.addMarker!(latLng);
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
                    polylines: [polylineFun(polylineList)],
                  ),
                  MarkerLayer(
                      markers: markerCoordinateList
                          .asMap()
                          .entries
                          .map((markerCoordinate) => markerDisplayFun(
                                  markerCoordinate.value,
                                  markerCoordinate.key,
                                  markerCoordinateList.length,
                                  () {
                                    widget.removeMarker!(markerCoordinate.key);
                              }))
                          .toList()),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          margin: const EdgeInsets.all(5.0),
                          child: FloatingActionButton(
                              backgroundColor: Colors.blue,
                              onPressed: () {
                                  widget.saveMapData();
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
