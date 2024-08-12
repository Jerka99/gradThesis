import 'package:flutter/gestures.dart';
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
  int? selectedMarkerIndex1;
  int? selectedMarkerIndex2;

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

  setSelectedMarkers(int index) {
    setState(() {
      if (selectedMarkerIndex1 == null) {
        selectedMarkerIndex1 = index;
      } else if (selectedMarkerIndex2 == null && index > selectedMarkerIndex1!) {
        selectedMarkerIndex2 = index;
      } else {
        selectedMarkerIndex1 = index;
        selectedMarkerIndex2 = null;
      }
    });
  }

  void toggleScrolling(bool value) {
    setState(() {
      enableScrollWheel = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0)),
        child: MouseRegion(
          onExit: (PointerExitEvent) {
          toggleScrolling(false);
          },
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                enableScrollWheel: enableScrollWheel,
                onTap: (pos, latLng) {
                  if(widget.addMarker != null) widget.addMarker!(latLng);
                  toggleScrolling(true);
                },
                onPositionChanged: (MapPosition, bool) {
                  toggleScrolling(true);
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
                              markerCoordinateList.length, (index) {
                              toggleScrolling(true);
                            widget.removeMarker != null ?
                            widget.removeMarker!(index) :
                            setSelectedMarkers(index);
                          },
                        selectedMarkerIndex1,
                        selectedMarkerIndex2
                  ))
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
          ),
        ));
  }
}
