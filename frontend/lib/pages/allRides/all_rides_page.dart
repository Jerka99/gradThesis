import 'package:flutter/material.dart';
import 'package:travel_mate/myMap/all_rides_list.dart';
import 'package:travel_mate/myMap/map_and_display_connector.dart';

class AllRidesPage extends StatefulWidget {
  Function fetchAllRides;
  AllRidesList allRidesList;
  int? selectedId;

  AllRidesPage(
      {required this.fetchAllRides, required this.allRidesList, this.selectedId, super.key});

  @override
  State<AllRidesPage> createState() => _AllRidesPageState();
}

class _AllRidesPageState extends State<AllRidesPage> {
  int? expandedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    AllRidesList.init();
    widget.fetchAllRides();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToRideId(widget.selectedId); // Replace 2 with the desired rideId
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // widget.allRidesList = AllRidesList(listOfRides: []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: widget.allRidesList.listOfRides.length,
        itemBuilder: (context, index) {
          bool isExpanded = expandedIndex == index;
          return AnimatedContainer(
            padding: const EdgeInsets.only(
              left: 20, right: 20, top: 10, bottom: 20),

          duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 25),
            height: isExpanded ? 700 : 350,
            child: MapAndDisplayConnector(
              markerCoordinateList: widget
                  .allRidesList.listOfRides[index].markerCoordinateList,
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
              mainMap: false,
              maxCapacity: widget.allRidesList.listOfRides[index].maxCapacity,
              rideId: widget.allRidesList.listOfRides[index].rideId,
              selectedMarkerIndex1: widget.allRidesList.listOfRides[index].selectedMarkerIndex1,
              selectedMarkerIndex2: widget.allRidesList.listOfRides[index].selectedMarkerIndex2,
              createdBy: widget.allRidesList.listOfRides[index].createdBy,
            ),
          );
        });
  }

  Future<void> _scrollToRideId(int? rideId) async {
    final index = widget.allRidesList.listOfRides.indexWhere((ride) => ride.rideId == rideId);
    if (index != -1) {
      _scrollController.animateTo(
        index * 375.0, // Assuming each item has a height of 350.0
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        expandedIndex = index;
      });
    }
  }

  DateTime epochToDataTime(double duration) {
    double epochTimeInMilliseconds = duration;
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(epochTimeInMilliseconds.toInt());
    return dateTime;
  }
}
