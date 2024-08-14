import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/user_role.dart';

import 'marker_and_polyline.dart';

class MyMap extends StatefulWidget {
  final List<LatLng>? markerCoordinateList;
  final List<LatLng>? polylineList;
  final Function() floatingSaveButton;
  final UserRole? userRole;
  final bool enableScrollWheel;
  final LatLng? currentUserLocation;
  final Function(LatLng)? addMarker;
  final Function(int index)? removeMarker;
  final List<AddressClass>? addressList;
  final double maxCapacity;
  final Function(double capacity)? changeCapacity;
  final bool alterableRoutesMap;
  final int? selectedMarkerIndex1;
  final int? selectedMarkerIndex2;
  final Function(int index)? setSelectedMarkers;

  const MyMap({
    super.key,
    this.markerCoordinateList,
    this.polylineList,
    required this.floatingSaveButton,
    this.userRole,
    this.enableScrollWheel = false,
    required this.currentUserLocation,
    this.addMarker,
    this.removeMarker,
    this.addressList,
    required this.maxCapacity,
    this.changeCapacity,
    required this.alterableRoutesMap,
    this.selectedMarkerIndex1,
    this.selectedMarkerIndex2,
    this.setSelectedMarkers,
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
          if(widget.addMarker == null) toggleScrolling(false);
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
                polylines: [MapUtils().createPolyline(polylineList)],
              ),
              MarkerLayer(
                  markers: markerCoordinateList
                      .asMap()
                      .entries
                      .map((markerCoordinate) => MapUtils().createMarker(
                      coordinate: markerCoordinate.value,
                      index: markerCoordinate.key,
                      markersNumber: markerCoordinateList.length,
                      deleteOrSelectFunction: (int index) {
                          toggleScrolling(true);
                          widget.removeMarker != null
                              ? widget.removeMarker!(index)
                              : widget.setSelectedMarkers != null ? widget.setSelectedMarkers!(index) : {};
                      },
                      selectedMarkerIndex1: UserRole.customer == widget.userRole ? widget.selectedMarkerIndex1 : null,
                      selectedMarkerIndex2: UserRole.customer == widget.userRole ? widget.selectedMarkerIndex2 : null,
                      stationCapacity: widget.addressList?[markerCoordinate.key].stationCapacity,
                      maxCapacity: widget.maxCapacity
                  ))
                      .toList()),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: const EdgeInsets.all(5.0),
                      child: FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            widget.floatingSaveButton();
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )))),
              Align(
                alignment: Alignment.topLeft,
                child: widget.alterableRoutesMap ? Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 5,),
                      const Text("Capacity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      CustomizableCounter(
                        showButtonText: false,
                        textColor: Colors.white,
                        // backgroundColor: Colors.blue,
                        borderWidth: 0,
                        borderColor: Colors.blue,
                        minCount: 0,
                        maxCount: 10,
                        onCountChange: (count) {
                        if(widget.changeCapacity != null) widget.changeCapacity!(count);
                        },
                      ),
                    ],
                  ),
                ) : Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(2),
                  height: 100,
                  width: 120,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                       const Flexible(
                         child: Flex(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          direction: Axis.horizontal,
                          children: [
                            Text("Station"),
                            Text("Capacity")
                          ],
                         ),
                       ),
                      if(widget.addressList != null) Flexible(child:
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.addressList!.length - 1,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text((index+1).toString())),
                                    Expanded(child: Text((widget.addressList?[index].stationCapacity ?? "0").toString())),
                                  ],
                                );
                              }),
                          ),
                        ],
                      )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
