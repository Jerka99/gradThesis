import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/app_state.dart';
import 'package:travel_mate/main.dart';
import 'package:travel_mate/myMap/map_data_class.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';
import '../main_api.dart';

class SaveMapData extends ReduxAction<AppState> {
  List<AddressClass> addressClassList;
  List<LatLng> markerCoordinateList;
  DateTime dateTime;
  double maxCapacity;

  SaveMapData({
    required this.addressClassList,
    required this.markerCoordinateList,
    required this.dateTime,
    required this.maxCapacity,
  });

  @override
  Future<AppState?> reduce() async {
    if (maxCapacity == 0) {
      appViewportKey.currentState
          ?.informUser("Capacity cant be 0!", Colors.red);
      return null;
    }
    if (addressClassList.length < 2) {
      appViewportKey.currentState
          ?.informUser("Choose minimal 2 marker points!", Colors.red);
      return null;
    }
    DateTime startTime = dateTime;
    int startTimeInMillisecond = startTime.millisecondsSinceEpoch;
    addressClassList.first.dataBetweenTwoAddresses?.duration =
        startTimeInMillisecond.toDouble();

    String? response = await MainApiClass()
        .saveMapData(addressClassList, markerCoordinateList, maxCapacity);

    if (response != null) {
      appViewportKey.currentState?.informUser(response);
    }
  }
}

class SaveUserRoute extends ReduxAction<AppState> {
  int rideId;
  int? firstMarker;
  int? lastMarker;

  SaveUserRoute({
    required this.rideId,
    this.firstMarker,
    this.lastMarker,
  });

  @override
  Future<AppState?> reduce() async {
    if (firstMarker == null || lastMarker == null) {
      appViewportKey.currentState
          ?.informUser("Choose 2 marker points!", Colors.red);
      return null;
    }
    int first = firstMarker! + 1;
    int last = lastMarker! + 1;
    List<int> sequence = List.generate(last - first, (index) => first + index);

    ResponseHandler? response =
        await MainApiClass().saveUserRoute(rideId, sequence);
    if (response?.status == 200) {
      appViewportKey.currentState?.informUser(response!.message, Colors.green);
    } else {
      appViewportKey.currentState?.informUser(response!.message, Colors.red);
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
      return state.copy(
          allRidesList: state.allRidesList.copyWith(listOfRides: ridesList));
    } catch (e) {
      appViewportKey.currentState
          ?.informUser('Failed to fetch rides: $e', Colors.red);
      return null;
    } finally {
      Navigator.of(appViewportKey.currentState!.context).pop();
    }
  }
}
