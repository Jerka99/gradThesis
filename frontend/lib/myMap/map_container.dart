import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/user_role.dart';

import '../../app_state.dart';
import 'myMap.dart';
import 'map_actions.dart';

class MapContainer extends StatelessWidget{

  UserRole? role;

  MapContainer({
    this.role,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {

        return MyMap(
          addMarkerAndPolyFun: vm.addMarkerAndPolyFun,
          addAddress: vm.addAddress,
          removeLastMarkerFun: vm.removeLastMarkerFun,
          markerCoordinateList: vm.markerCoordinateList,
          polylineList: vm.polylineList,
          addressesList: vm.addressesList,
        );},
    );
  }
}

class _ViewModel extends Vm{

  Function(LatLng, List<LatLng>) addMarkerAndPolyFun;
  Function(Geocoding) addAddress;
  Function(int) removeLastMarkerFun;
  List<LatLng> markerCoordinateList = [];
  List<List<LatLng>> polylineList = [];
  List<Map<Coordinate, String>> addressesList;

  _ViewModel({
    required this.addMarkerAndPolyFun,
    required this.addAddress,
    required this.removeLastMarkerFun,
    required this.markerCoordinateList,
    required this.polylineList,
    required this.addressesList
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      addMarkerAndPolyFun: (marker, polyline) {
          store.dispatch(MapActionAddMarkerAndPolyline(marker, polyline));
      },
      addAddress: (address) {
        store.dispatch(MapActionAddressesManager(address));
      },
      removeLastMarkerFun : (key) {store.dispatch(RemoveLastMarker(key));},
      markerCoordinateList: store.state.mapData!.markerCoordinateList,
      polylineList: store.state.mapData!.polylineList,
      addressesList: store.state.mapData!.addressesList
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is _ViewModel &&
          runtimeType == other.runtimeType &&
          addMarkerAndPolyFun == other.addMarkerAndPolyFun &&
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
      removeLastMarkerFun.hashCode ^
      markerCoordinateList.hashCode ^
      polylineList.hashCode ^
      addressesList.hashCode;
}
