import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/main.dart';
import '../app_state.dart';

class FetchLocationAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    if(state.currentUserLocation == null){
    Position position;
    try {
      appViewportKey.currentState?.showLoading("current location");
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      appViewportKey.currentState?.informUser('Location is Fetched', Colors.green);
        return state.copy(
          currentUserLocation: LatLng(position.latitude, position.longitude),
        );
    } catch (e) {
      appViewportKey.currentState?.informUser('Failed to get location: $e', Colors.red);
      return null;
    }
    finally{
      Navigator.of(appViewportKey.currentState!.context).pop();
    }
  }
  }
}
