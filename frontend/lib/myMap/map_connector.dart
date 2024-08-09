import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/main_api.dart';
import 'package:travel_mate/user_role.dart';

import '../../app_state.dart';
import 'myMap.dart';
import 'map_actions.dart';

class Factory extends VmFactory<AppState, MapConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
        markerCoordinateList: state.mapData!.markerCoordinateList,
        polylineList: state.mapData!.polylineList,
        addMapData: (latLng) {
            dispatch(InitFetch(latLng: latLng));
          },
          removeLastMarkerFun : (key) {dispatch(RemoveLastMarker(key));},
          saveMapData: () {dispatch(SaveMapData());},
          userRole: state.user.role,
          currentUserLocation: state.currentUserLocation,
      );
}

class ViewModel extends Vm {

  List<LatLng> markerCoordinateList = [];
  List<List<LatLng>> polylineList = [];
  Function(LatLng)? addMapData;
  Function(int)? removeLastMarkerFun;
  Function()? saveMapData;
  UserRole? userRole;
  LatLng? currentUserLocation;

  ViewModel({
    required this.markerCoordinateList,
    required this.polylineList,
    this.saveMapData,
    this.addMapData,
    this.removeLastMarkerFun,
    this.userRole,
    this.currentUserLocation}
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          addMapData == other.addMapData &&
          removeLastMarkerFun == other.removeLastMarkerFun &&
          saveMapData == other.saveMapData &&
          markerCoordinateList == other.markerCoordinateList &&
          polylineList == other.polylineList &&
          userRole == other.userRole &&
          currentUserLocation == other.currentUserLocation;

  @override
  int get hashCode =>
      super.hashCode ^
      addMapData.hashCode ^
      removeLastMarkerFun.hashCode ^
      saveMapData.hashCode ^
      markerCoordinateList.hashCode ^
      polylineList.hashCode ^
      userRole.hashCode ^
      currentUserLocation.hashCode;

  @override
  String toString() {
    return 'ViewModel{markerCoordinateList: $markerCoordinateList, polylineList: $polylineList, addMapData: $addMapData, removeLastMarkerFun: $removeLastMarkerFun, saveMapData: $saveMapData, userRole: $userRole, currentUserLocation: $currentUserLocation}';
  }
}

class MapConnector extends StatelessWidget{

  UserRole? role;

  MapConnector({
    this.role,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {

        return MyMap(
          markerCoordinateList: vm.markerCoordinateList,
          polylineList: vm.polylineList,
          addMapData: vm.addMapData,
          removeLastMarkerFun: vm.removeLastMarkerFun,
          saveMapData: vm.saveMapData,
          userRole: vm.userRole,
          enableScrollWheel: true,
          currentUserLocation: vm.currentUserLocation
        );},
    );
  }
}
