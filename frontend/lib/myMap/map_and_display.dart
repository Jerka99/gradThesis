import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/model.dart';

import '../pages/display/from_to_display.dart';
import 'address_class.dart';
import 'coordinates_api.dart';
import 'my_map.dart';

class MapAndDisplay extends StatefulWidget {
  List<LatLng>? markerCoordinateList;
  List<LatLng>? polylineList;
  LatLng? currentUserLocation;
  List<AddressClass>? addressesList;
  Function(List<AddressClass>, List<LatLng>, DateTime, double)? saveMapData;
  Function(int rideId, int? firstMarker, int? lastMarker)? saveUserRoute;
  UserData? userData;
  DateTime? dateTime;
  bool? isExpanded;
  Function? expandButton;
  bool enableScrollWheel;
  bool alterableRoutesMap;
  double maxCapacity;
  int? rideId;
  int? selectedMarkerIndex1;
  int? selectedMarkerIndex2;

  MapAndDisplay(
      {this.markerCoordinateList,
      this.polylineList,
      this.currentUserLocation,
      this.addressesList,
      this.saveMapData,
      this.saveUserRoute,
      required this.userData,
      this.dateTime,
      this.isExpanded,
      this.expandButton,
      required this.enableScrollWheel,
      required this.alterableRoutesMap,
      required this.maxCapacity,
      this.rideId,
      this.selectedMarkerIndex1,
      this.selectedMarkerIndex2,
      super.key});

  @override
  State<MapAndDisplay> createState() => _MapAndDisplayState();
}

class _MapAndDisplayState extends State<MapAndDisplay> {
  late AnimationController controller;
  late List<LatLng> markerCoordinateList;
  late List<LatLng> tempMarkerCoordinateList;
  late List<LatLng> polylineList;
  late List<AddressClass> addressClassList;
  bool whileLoopTriggered = false;
  late DateTime? dateTime;
  late double maxCapacity;
  late int? selectedMarkerIndex1;
  late int? selectedMarkerIndex2;

  @override
  void initState() {
    super.initState();
    dateTime = widget.dateTime ?? DateTime.now();
    markerCoordinateList = widget.markerCoordinateList ?? [];
    tempMarkerCoordinateList = [];
    polylineList = widget.polylineList ?? [];
    addressClassList = widget.addressesList?.map((address) => AddressClass(
        city: address.city, // Copy each field from the original object
        fullAddress: address.fullAddress,
        dataBetweenTwoAddresses: address.dataBetweenTwoAddresses,
        stationCapacity: address.stationCapacity
    )).toList() ?? [];
    // addressClassList = widget.addressesList ?? [];
    maxCapacity = widget.maxCapacity;
    selectedMarkerIndex1 = widget.selectedMarkerIndex1;
    selectedMarkerIndex2 = widget.selectedMarkerIndex2;
  }

  @override
  void didUpdateWidget(covariant MapAndDisplay oldWidget) {
    if(widget.isExpanded != null && widget.isExpanded!) {
      fetchPolylineData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
      AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: widget.isExpanded == null ? 400 : widget.isExpanded! ? 300 : 0,
          child: ClipRect(
              // removes unnecessary border from MyMap widget when its collapsed
              child: MyMap(
            userRole: widget.userData?.role,
            markerCoordinateList: markerCoordinateList,
            polylineList: polylineList,
            addMarker: widget.alterableRoutesMap ? addMarker : null,
            removeMarker: widget.alterableRoutesMap ? removeMarker : null,
            floatingSaveButton: () {
              if(widget.alterableRoutesMap){
              if (!whileLoopTriggered) {
                widget.saveMapData!(addressClassList, markerCoordinateList, dateTime!, maxCapacity);
                }
              }
              else{
                widget.saveUserRoute!(widget.rideId!, selectedMarkerIndex1, selectedMarkerIndex2);
              }
            },
            currentUserLocation: widget.currentUserLocation,
            enableScrollWheel: widget.enableScrollWheel,
            addressList: addressClassList,
            maxCapacity: widget.maxCapacity,
            changeCapacity: (capacity) => {
              widget.alterableRoutesMap ? setState((){
                maxCapacity = capacity;
              }) : null},
            alterableRoutesMap: widget.alterableRoutesMap,
            selectedMarkerIndex1: selectedMarkerIndex1,
            selectedMarkerIndex2: selectedMarkerIndex2,
            setSelectedMarkers: setSelectedMarkers
          ))
      ),
      SizedBox(
        child: Container(
          height: 10,
        ),
      ),
      Expanded(
        child: FromToDisplay(
          addressesList: addressClassList,
          dateTime: dateTime,
          setDateTime: (date) => setState(() {
            dateTime = date;
          }),
          expandButton: widget.expandButton,
          displayMore: widget.isExpanded ?? true,
        ),
      )
    ]);
  }

  Future<void> fetchPolylineData() async {
    var mappedCoordinateList = markerCoordinateList
        .map((marker) => [marker.longitude, marker.latitude])
        .toList();
    ResponseData? fetchedPolylineCoordinates = await fetchCoordinates(mappedCoordinateList);

    if (fetchedPolylineCoordinates != null) {
      setState(() {
        polylineList = fetchedPolylineCoordinates.coordinates;
      });
    }
    return null;
  }

  void getAddressData() async {
    if (!whileLoopTriggered) {
      whileLoopTriggered = true;
      while (addressClassList
          .any((address) => address.fullAddress == "loading")) {
        int indexToUpdate = addressClassList
            .indexWhere((address) => address.fullAddress == "loading");

        if (indexToUpdate == -1) {
          break; // Exit loop if no "loading" address is found
        }

        await Future.delayed(const Duration(milliseconds: 2000));
        await fetchAddressName(
            markerCoordinateList[indexToUpdate], indexToUpdate, (newAddress) {
          setState(() {
            addressClassList[indexToUpdate].fullAddress =
                newAddress.fullAddress;
            addressClassList[indexToUpdate].city = newAddress.city;
          });
        });
      }
      whileLoopTriggered = false; // Reset the flag once the loop completes
    }
  }

  void getPolyline(deleting) async {
    var mappedCoordinateList = tempMarkerCoordinateList
        .map((marker) => [marker.longitude, marker.latitude])
        .toList();
    ResponseData? fetchedPolylineCoordinates =
    await fetchCoordinates(mappedCoordinateList);
    if (fetchedPolylineCoordinates != null) {
      DataBetweenTwoAddresses dataBetweenTwoAddresses =
      DataBetweenTwoAddresses(fetchedPolylineCoordinates.duration,
          fetchedPolylineCoordinates.distance);
      setState(() {
        polylineList = fetchedPolylineCoordinates.coordinates;
        if (!deleting) {
          markerCoordinateList
              .add(fetchedPolylineCoordinates.coordinates.last);
          tempMarkerCoordinateList = [...markerCoordinateList];
          addressClassList.add(AddressClass(
              fullAddress: "loading",
              city: "loading",
              dataBetweenTwoAddresses: dataBetweenTwoAddresses));
          getAddressData();
        }
      });
    } else {
      tempMarkerCoordinateList.removeLast();
    }
  }

  void addMarker(LatLng latLng) {
    tempMarkerCoordinateList.add(latLng);
    getPolyline(false);
  }

  void removeMarker(int index) {
    if (!whileLoopTriggered) {
      setState(() {
        markerCoordinateList.removeAt(index);
        tempMarkerCoordinateList.removeAt(index);
        addressClassList.removeAt(index);
        markerCoordinateList.length <= 1
            ? polylineList = []
            : getPolyline(true);
      });
    }
  }

  setSelectedMarkers(int index) {
    setState(() {
      if (selectedMarkerIndex1 == null) {
        addressClassList[index].stationCapacity = addressClassList[index].stationCapacity! - 1;
        selectedMarkerIndex1 = index;
      } else if (selectedMarkerIndex2 == null && index > selectedMarkerIndex1!) {
        for(int? i = selectedMarkerIndex1! + 1; i! < index!; i++) {
          addressClassList[i].stationCapacity =
              addressClassList[i].stationCapacity! - 1;
        }
        selectedMarkerIndex2 = index;
      } else {
        addressClassList = widget.addressesList?.map((address) => AddressClass(
            city: address.city,
            fullAddress: address.fullAddress,
            dataBetweenTwoAddresses: address.dataBetweenTwoAddresses,
            stationCapacity: address.stationCapacity
        )).toList() ?? [];
        selectedMarkerIndex1 = null;
        selectedMarkerIndex2 = null;
      }
    });
  }

}
