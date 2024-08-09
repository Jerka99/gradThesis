import 'package:flutter/material.dart';
import 'package:travel_mate/myMap/all_rides_list.dart';
import 'package:travel_mate/myMap/myMap.dart';
import 'package:travel_mate/pages/display/from_to_display.dart';

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
          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isExpanded ? 300 : 0,
                child: ClipRect(// removes unnecessary border from MyMap widget when its collapsed
                  child: MyMap(
                    markerCoordinateList: widget
                        .allRidesList.listOfRides[index].markerCoordinateList,
                    polylineList:
                        widget.allRidesList.listOfRides[index].polylineList,
                    currentUserLocation: widget
                        .allRidesList.listOfRides[index].markerCoordinateList.first,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isExpanded ? 300 : 152,
                color: Colors.white,
                child: FromToDisplay(
                  addressesList:
                      widget.allRidesList.listOfRides[index].addressesList,
                  dateTime: epochToDataTime(widget
                      .allRidesList
                      .listOfRides[index]
                      .addressesList[0]
                      .dataBetweenTwoAddresses!
                      .duration),
                  displayMore: isExpanded,
                  displayCalendar: false,
                  expandButton: () => setState(() {
                    isExpanded ? expandedIndex = null : expandedIndex = index;
                  }),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
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
