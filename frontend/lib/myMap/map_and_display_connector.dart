import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/model.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/myMap/map_and_display.dart';
import 'package:travel_mate/user_role.dart';

import '../../app_state.dart';
import 'map_actions.dart';

class Factory extends VmFactory<AppState, MapAndDisplayConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
        saveMapData: (List<AddressClass> addressClassList,
            List<LatLng> markerCoordinateList, DateTime dateTime, double maxCapacity) {
          state.user.role == UserRole.driver ?
          dispatch(SaveMapData(addressClassList: addressClassList,
              markerCoordinateList: markerCoordinateList, dateTime: dateTime, maxCapacity: maxCapacity)) :
          dispatch(SaveMapData(addressClassList: addressClassList, //desiredRides
              markerCoordinateList: markerCoordinateList, dateTime: dateTime, maxCapacity: maxCapacity)
          );
        },
        userData: state.user,
        currentUserLocation: state.currentUserLocation,
        saveUserRoute: (int rideId, List<int> sequence){
          print(rideId);
        }
      );
}

class ViewModel extends Vm {

  Function(LatLng)? addMapData;
  Function(int)? removeLastMarkerFun;
  Function(List<AddressClass>, List<LatLng>, DateTime, double) saveMapData;
  UserData? userData;
  LatLng? currentUserLocation;
  Function(int rideId, List<int> sequence)? saveUserRoute;

  ViewModel({
    required this.saveMapData,
    this.addMapData,
    this.removeLastMarkerFun,
    this.userData,
    this.currentUserLocation,
    this.saveUserRoute});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is ViewModel &&
              runtimeType == other.runtimeType &&
              addMapData == other.addMapData &&
              removeLastMarkerFun == other.removeLastMarkerFun &&
              saveMapData == other.saveMapData &&
              userData == other.userData &&
              currentUserLocation == other.currentUserLocation;

  @override
  int get hashCode =>
      super.hashCode ^
      addMapData.hashCode ^
      removeLastMarkerFun.hashCode ^
      saveMapData.hashCode ^
      userData.hashCode ^
      currentUserLocation.hashCode;

  @override
  String toString() {
    return 'ViewModel{addMapData: $addMapData, removeLastMarkerFun: $removeLastMarkerFun, saveMapData: $saveMapData, userData: $userData, currentUserLocation: $currentUserLocation}';
  }
}

class MapAndDisplayConnector extends StatelessWidget {
  List<LatLng>? markerCoordinateList;
  List<LatLng>? polylineList;
  LatLng? currentUserLocation;
  List<AddressClass>? addressesList;
  DateTime? dateTime;
  Function? expandButton;
  bool? isExpanded;
  bool enableScrollWheel;
  bool alterableRoutesMap;
  double maxCapacity;
  int? rideId;

  MapAndDisplayConnector({
    this.polylineList,
    this.markerCoordinateList,
    this.currentUserLocation,
    this.addressesList,
    this.dateTime,
    this.expandButton,
    this.isExpanded,
    this.enableScrollWheel = true,
    this.alterableRoutesMap = true,
    this.maxCapacity = 0,
    this.rideId,
    super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return MapAndDisplay(
          markerCoordinateList: markerCoordinateList,
          polylineList: polylineList,
          saveMapData: vm.saveMapData,
          saveUserRoute: vm.saveUserRoute,
          userData: vm.userData,
          currentUserLocation: currentUserLocation ?? vm.currentUserLocation,
          addressesList: addressesList,
          dateTime: dateTime,
          expandButton: expandButton,
          isExpanded: isExpanded,
          enableScrollWheel: enableScrollWheel,
          alterableRoutesMap: alterableRoutesMap,
          maxCapacity: maxCapacity,
          rideId: rideId
        );
      },
    );
  }
}
