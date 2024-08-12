import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/myMap/all_rides_list.dart';
import 'package:travel_mate/myMap/map_and_display_connector.dart';

import '../../myMap/coordinates_api.dart';

class AllRidesPage extends StatefulWidget {
  Function fetchAllRides;
  AllRidesList allRidesList;

  AllRidesPage(
      {required this.fetchAllRides, required this.allRidesList, super.key});

  @override
  State<AllRidesPage> createState() => _AllRidesPageState();
}

class _AllRidesPageState extends State<AllRidesPage> {
  int? expandedIndex;
  List<List<LatLng>> allPolylineLists = [];

  @override
  void initState() {
    super.initState();
    widget.fetchAllRides();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.allRidesList.listOfRides.length,
        itemBuilder: (context, index) {
          bool isExpanded = expandedIndex == index;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 50),
            height: isExpanded ? 700 : 162,
            child: MapAndDisplayConnector(
              markerCoordinateList: widget
                  .allRidesList.listOfRides[index].markerCoordinateList,
              polylineList:
              widget.allRidesList.listOfRides[index].polylineList,
              currentUserLocation: widget
                  .allRidesList.listOfRides[index].markerCoordinateList.first,
              addressesList: widget.allRidesList.listOfRides[index].addressesList,
              dateTime: epochToDataTime(widget
                  .allRidesList
                  .listOfRides[index]
                  .addressesList[0]
                  .dataBetweenTwoAddresses!
                  .duration),
              expandButton: () => setState(() {
                isExpanded ? expandedIndex = null : expandedIndex = index;
              }),
              isExpanded: isExpanded,
              enableScrollWheel: false,
              editingAllowed: false,
            ),
          );
        });
  }

  DateTime epochToDataTime(double duration) {
    double epochTimeInMiliseconds = duration;
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(epochTimeInMiliseconds.toInt());
    return dateTime;
  }
}
