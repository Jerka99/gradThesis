import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/model.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/user_role.dart';

import 'marker_and_polyline.dart';

class MyMap extends StatefulWidget {
  final List<LatLng>? markerCoordinateList;
  final List<LatLng>? polylineList;
  final Function() floatingSaveButton;
  final UserData? userData;
  final bool enableScrollWheel;
  final LatLng? currentUserLocation;
  final Function(LatLng)? addMarker;
  final Function(int index)? removeMarker;
  final List<AddressClass>? addressList;
  final List<AddressClass>? unchangeableAddressList;
  final double maxCapacity;
  final Function(double capacity)? changeCapacity;
  final bool mainMap;
  final int? selectedMarkerIndex1;
  final int? selectedMarkerIndex2;
  final Function(int index)? setSelectedMarkers;
  final bool isRideCancelable;
  final Function() deleteRide;
  final int? createdBy;

  const MyMap({
    super.key,
    this.markerCoordinateList,
    this.polylineList,
    required this.floatingSaveButton,
    this.userData,
    this.enableScrollWheel = false,
    required this.currentUserLocation,
    this.addMarker,
    this.removeMarker,
    this.addressList,
    this.unchangeableAddressList,
    required this.maxCapacity,
    this.changeCapacity,
    required this.mainMap,
    this.selectedMarkerIndex1,
    this.selectedMarkerIndex2,
    this.setSelectedMarkers,
    this.isRideCancelable = false,
    required this.deleteRide,
    this.createdBy,
  });

  @override
  State<MyMap> createState() => _MyMap();
}

class _MyMap extends State<MyMap> {
  late bool enableScrollWheel;
  final MapController _mapController = MapController();
  late List<LatLng> markerCoordinateList;
  late List<LatLng> polylineList;
  late bool isRideCancelable;

  @override
  void initState() {
    super.initState();
    markerCoordinateList = widget.markerCoordinateList ?? <LatLng>[];
    polylineList = widget.polylineList ?? [];
    enableScrollWheel = widget.enableScrollWheel;
    isRideCancelable = widget.isRideCancelable;
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

  MaterialColor getMarkerColor(int index, int markersLength){
    if(index == widget.selectedMarkerIndex1 || index == widget.selectedMarkerIndex2 ||
        ((widget.selectedMarkerIndex2 != null && widget.selectedMarkerIndex1 != null)
            && (index < widget.selectedMarkerIndex2! && index > widget.selectedMarkerIndex1!))) {
      return Colors.green;
    }
    if(widget.addressList?[index].stationCapacity == 0){
      return Colors.grey;
    }

    if(index ==  markersLength - 1) {
      return Colors.blue;
    }

    return Colors.red;
  }

  bool isAllStationsCapacityGood(int index){
    if(widget.selectedMarkerIndex1 != null) {
      for (int i = widget.selectedMarkerIndex1!; i <= index; i++) {
        if(widget.unchangeableAddressList![i].stationCapacity! < 1) return false;
      }
      return true;
    }
    else{
    return widget.unchangeableAddressList![index].stationCapacity! > 0;
    }
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
                              if (!isRideCancelable && (widget.mainMap || isAllStationsCapacityGood(index))) {
                                if (widget.removeMarker != null) {
                                  widget.removeMarker!(index);
                                }
                                if (widget.setSelectedMarkers != null && !widget.mainMap) {
                                  widget.setSelectedMarkers!(index);
                                }
                                ;
                              }
                            },
                      selectedMarkerIndex1: widget.selectedMarkerIndex1,
                      selectedMarkerIndex2: widget.selectedMarkerIndex2,
                      stationCapacity: widget.addressList?[markerCoordinate.key].stationCapacity,
                      maxCapacity: widget.maxCapacity,
                      markerColor: getMarkerColor(markerCoordinate.key, markerCoordinateList.length),
                  ))
                      .toList()),
               Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        margin: const EdgeInsets.all(5.0),
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!isRideCancelable)
                              Flexible(
                                child: FloatingActionButton(
                                  backgroundColor: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      if(!widget.mainMap && widget.userData!.role == UserRole.customer && widget.selectedMarkerIndex1 != null && widget.selectedMarkerIndex2 != null) isRideCancelable = true;
                                    });
                                    widget.floatingSaveButton();
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            if (isRideCancelable && !widget.mainMap && (widget.userData?.id == widget.createdBy || widget.userData?.role == UserRole.customer && isRideCancelable))
                              Flexible(
                                child: FloatingActionButton(
                                  backgroundColor: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      if(widget.userData!.role == UserRole.customer) isRideCancelable = false;
                                    });
                                    widget.deleteRide();
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                    )),
              if(widget.userData!.role == UserRole.driver || !widget.mainMap) Align(
                alignment: Alignment.topLeft,
                child: widget.mainMap ? Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      const SizedBox(height: 5,),
                      const Text("Capacity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      Flexible(
                        child: CustomizableCounter(
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
