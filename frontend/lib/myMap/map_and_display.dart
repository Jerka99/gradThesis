import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

import '../pages/display/from_to_display.dart';
import '../user_role.dart';
import 'address_class.dart';
import 'coordinates_api.dart';
import 'my_map.dart';

class MapAndDisplay extends StatefulWidget {
  List<LatLng>? markerCoordinateList;
  List<LatLng>? polylineList;
  LatLng? currentUserLocation;
  List<AddressClass>? addressesList;
  Function(List<AddressClass>, List<LatLng>, DateTime) saveMapData;
  UserRole? role;
  DateTime? dateTime;
  bool? isExpanded;
  Function? expandButton;
  bool enableScrollWheel;
  bool editingAllowed;

  MapAndDisplay(
      {this.markerCoordinateList,
      this.polylineList,
      this.currentUserLocation,
      this.addressesList,
      required this.saveMapData,
      required this.role,
      this.dateTime,
      this.isExpanded,
      this.expandButton,
      required this.enableScrollWheel,
      required this.editingAllowed,
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

  @override
  void initState() {
    super.initState();
    dateTime = widget.dateTime ?? DateTime.now();
    markerCoordinateList = widget.markerCoordinateList ?? [];
    tempMarkerCoordinateList = [];
    polylineList = widget.polylineList ?? [];
    addressClassList = widget.addressesList ?? [];
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
            userRole: widget.role,
            markerCoordinateList: markerCoordinateList,
            polylineList: polylineList,
            addMarker: widget.editingAllowed ? addMarker : null,
            removeMarker: widget.editingAllowed ? removeMarker : null,
            saveMapData: () {
              if (!whileLoopTriggered) {
                widget.saveMapData(
                    addressClassList, markerCoordinateList, dateTime!);
              }
            },
            currentUserLocation: widget.currentUserLocation,
            enableScrollWheel: widget.enableScrollWheel,
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

        if (indexToUpdate == -1)
          break; // Exit loop if no "loading" address is found

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

}
