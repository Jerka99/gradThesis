import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/app_state.dart';
import 'package:travel_mate/main.dart';
import 'package:travel_mate/myMap/map_data_class.dart';
import 'package:travel_mate/myMap/address_class.dart';
import '../main_api.dart';


class SaveMapData extends ReduxAction<AppState> {
  List<AddressClass> addressClassList;
  List<LatLng> markerCoordinateList;
  DateTime dateTime;

  SaveMapData({
    required this.addressClassList,
    required this.markerCoordinateList,
    required this.dateTime,
});

  @override
  Future<AppState?> reduce() async {
    if(addressClassList.length > 1) {
      DateTime startTime = dateTime;
      int startTimeInMillisecond = startTime.millisecondsSinceEpoch;
      addressClassList.first.dataBetweenTwoAddresses?.duration = startTimeInMillisecond.toDouble();

      String? response = await MainApiClass().saveMapData(
          addressClassList, markerCoordinateList);

      if(response != null) {
        appViewportKey.currentState?.informUser(response);
      }
    }
    else {
      appViewportKey.currentState?.informUser("Choose minimal 2 marker points!", Colors.red);
    }
  }
}

class FetchMapData extends ReduxAction<AppState> {
  FetchMapData();

  @override
  Future<AppState?> reduce() async {
    try {
      appViewportKey.currentState?.showLoading("all rides");
      List<MapData> ridesList = await MainApiClass().fetchAllRides();
      return state.copy(allRidesList: state.allRidesList.copyWith(listOfRides: ridesList));
    }catch (e) {
      appViewportKey.currentState?.informUser('Failed to fetch rides: $e', Colors.red);
      return null;
    }
    finally{
      Navigator.of(appViewportKey.currentState!.context).pop();
    }
  }
}
