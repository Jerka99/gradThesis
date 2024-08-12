import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/myMap/map_and_display.dart';
import 'package:travel_mate/user_role.dart';

import '../../app_state.dart';
import 'map_actions.dart';

class Factory extends VmFactory<AppState, MapAndDisplayConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
        saveMapData: (List<AddressClass> addressClassList, List<LatLng> markerCoordinateList, DateTime dateTime)
        {
          dispatch(SaveMapData(addressClassList: addressClassList, markerCoordinateList: markerCoordinateList, dateTime: dateTime));
        },
        userRole: state.user.role,
        currentUserLocation: state.currentUserLocation,
      );
}

class ViewModel extends Vm {

  Function(LatLng)? addMapData;
  Function(int)? removeLastMarkerFun;
  Function(List<AddressClass>, List<LatLng>, DateTime) saveMapData;
  UserRole? userRole;
  LatLng? currentUserLocation;

  ViewModel({
    required this.saveMapData,
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
              userRole == other.userRole &&
              currentUserLocation == other.currentUserLocation;

  @override
  int get hashCode =>
      super.hashCode ^
      addMapData.hashCode ^
      removeLastMarkerFun.hashCode ^
      saveMapData.hashCode ^
      userRole.hashCode ^
      currentUserLocation.hashCode;

  @override
  String toString() {
    return 'ViewModel{addMapData: $addMapData, removeLastMarkerFun: $removeLastMarkerFun, saveMapData: $saveMapData, userRole: $userRole, currentUserLocation: $currentUserLocation}';
  }
}

class MapAndDisplayConnector extends StatelessWidget{
  List<LatLng>? markerCoordinateList;
  List<LatLng>? polylineList;
  LatLng? currentUserLocation;
  List<AddressClass>? addressesList;
  DateTime? dateTime;
  Function? expandButton;
  bool? isExpanded;

  MapAndDisplayConnector({
    this.polylineList,
    this.markerCoordinateList,
    this.currentUserLocation,
    this.addressesList,
    this.dateTime,
    this.expandButton,
    this.isExpanded,
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
            role: vm.userRole,
            currentUserLocation: currentUserLocation ?? vm.currentUserLocation,
            addressesList: addressesList,
            dateTime: dateTime,
            expandButton: expandButton,
            isExpanded: isExpanded,
        );},
    );
  }
}
