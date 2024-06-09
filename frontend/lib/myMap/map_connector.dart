import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/myMap/address_class.dart';
import 'package:redux_example/user_role.dart';

import '../../app_state.dart';
import 'myMap.dart';
import 'map_actions.dart';

class Factory extends VmFactory<AppState, MapConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
          addMapData: (latLng) {
            dispatch(InitFetch(latLng: latLng));
          },
          removeLastMarkerFun : (key) {dispatch(RemoveLastMarker(key));},
          markerCoordinateList: state.mapData!.markerCoordinateList,
          polylineList: state.mapData!.polylineList,
          addressesList: state.mapData!.addressesList,
          userRole: state.user.role,
      );
}

class ViewModel extends Vm {

  Function(LatLng) addMapData;
  Function(int) removeLastMarkerFun;
  List<LatLng> markerCoordinateList = [];
  List<List<LatLng>> polylineList = [];
  List<AddressClass> addressesList;
  UserRole? userRole;

  ViewModel({
    required this.addMapData,
    required this.removeLastMarkerFun,
    required this.markerCoordinateList,
    required this.polylineList,
    required this.addressesList,
    required this.userRole,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          addMapData == other.addMapData &&
          removeLastMarkerFun == other.removeLastMarkerFun &&
          markerCoordinateList == other.markerCoordinateList &&
          polylineList == other.polylineList &&
          addressesList == other.addressesList &&
          userRole == other.userRole;

  @override
  int get hashCode =>
      super.hashCode ^
      addMapData.hashCode ^
      removeLastMarkerFun.hashCode ^
      markerCoordinateList.hashCode ^
      polylineList.hashCode ^
      addressesList.hashCode ^
      userRole.hashCode;
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
          addMapData: vm.addMapData,
          removeLastMarkerFun: vm.removeLastMarkerFun,
          markerCoordinateList: vm.markerCoordinateList,
          polylineList: vm.polylineList,
          addressesList: vm.addressesList,
          userRole: vm.userRole,
        );},
    );
  }
}
