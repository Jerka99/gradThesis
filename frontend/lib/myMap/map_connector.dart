import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/user_role.dart';

import '../../app_state.dart';
import 'myMap.dart';
import 'map_actions.dart';

class Factory extends VmFactory<AppState, MapConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
          addMapData: (latlng) {
            dispatch(InitFetch(latlng: latlng));
          },
          addMarkerAndPolyFun: (marker, polyline) {
            dispatch(MapActionAddMarkerAndPolyline(marker, polyline));
          },
          addAddress: (address) {
            dispatch(MapActionAddressesManager(address));
          },
          removeLastMarkerFun : (key) {dispatch(RemoveLastMarker(key));},
          markerCoordinateList: state.mapData!.markerCoordinateList,
          polylineList: state.mapData!.polylineList,
          addressesList: state.mapData!.addressesList
      );
}

class ViewModel extends Vm{

  Function(LatLng, List<LatLng>) addMarkerAndPolyFun;
  Function(Geocoding) addAddress;
  Function(LatLng) addMapData;
  Function(int) removeLastMarkerFun;
  List<LatLng> markerCoordinateList = [];
  List<List<LatLng>> polylineList = [];
  List<Map<Coordinate, String>> addressesList;

  ViewModel({
    required this.addMarkerAndPolyFun,
    required this.addAddress,
    required this.addMapData,
    required this.removeLastMarkerFun,
    required this.markerCoordinateList,
    required this.polylineList,
    required this.addressesList
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is ViewModel &&
              runtimeType == other.runtimeType &&
              addMarkerAndPolyFun == other.addMarkerAndPolyFun &&
              addMapData == other.addMapData &&
              addAddress == other.addAddress &&
              removeLastMarkerFun == other.removeLastMarkerFun &&
              markerCoordinateList == other.markerCoordinateList &&
              polylineList == other.polylineList &&
              addressesList == other.addressesList;

  @override
  int get hashCode =>
      super.hashCode ^
      addMarkerAndPolyFun.hashCode ^
      addAddress.hashCode ^
      addMapData.hashCode ^
      removeLastMarkerFun.hashCode ^
      markerCoordinateList.hashCode ^
      polylineList.hashCode ^
      addressesList.hashCode;
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
          addMarkerAndPolyFun: vm.addMarkerAndPolyFun,
          addAddress: vm.addAddress,
          addMapData: vm.addMapData,
          removeLastMarkerFun: vm.removeLastMarkerFun,
          markerCoordinateList: vm.markerCoordinateList,
          polylineList: vm.polylineList,
          addressesList: vm.addressesList,
        );},
    );
  }
}
