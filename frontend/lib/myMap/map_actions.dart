import 'package:async_redux/async_redux.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/app_state.dart';

import 'coordinates_api.dart';



class InitFetch extends ReduxAction<AppState> {
  String? startPoint;
  String? endPoint;
  LatLng latlng;
  String? tempStartPoint;
  String? tempEndPoint;
  bool loading = false;

  InitFetch({
    required this.latlng
});

  void handleApiPath() {
    List<LatLng> markerCoordinateList = store.state.mapData!.markerCoordinateList;

    if (!loading) {

      if (markerCoordinateList.isEmpty) {
        startPoint = "${latlng.longitude}, ${latlng.latitude}";
        endPoint = startPoint;
      } else {
        LatLng lastMarker = markerCoordinateList[markerCoordinateList.length - 1];
        tempStartPoint = startPoint; //no wrong polylines if we re clicking on the sea
        tempEndPoint = endPoint;
        startPoint = "${lastMarker.longitude}, ${lastMarker.latitude}"; //?? startPoint
        endPoint = "${latlng?.longitude}, ${latlng?.latitude}";
      }
    }
  }

  @override
  Future<AppState?> reduce() async {

    handleApiPath();
    ResponseData? coordinatesResponse = await fetchCoordinates(startPoint, endPoint, (bool value) => {loading = value});


    if (coordinatesResponse!.coordinates.isNotEmpty) {
      dispatch(MapActionAddMarkerAndPolyline(coordinatesResponse.coordinates[coordinatesResponse.coordinates.length - 1], coordinatesResponse.coordinates));
      await fetchAddressName(endPoint, (addressResponse) => dispatch(MapActionAddressesManager(addressResponse, coordinatesResponse.duration, coordinatesResponse.distance)), true);
    } else {
        startPoint = tempStartPoint;
        endPoint = tempEndPoint;
      }
    return null;
    }

  }

class MapActionAddMarkerAndPolyline extends ReduxAction<AppState> {
  LatLng marker;
  List<LatLng> polyline = [];

  MapActionAddMarkerAndPolyline(this.marker, this.polyline);

  @override
  AppState? reduce() {
    List<List<LatLng>> polylinesListCopy = [
      ...?store.state.mapData?.polylineList
    ];
    polylinesListCopy.add(polyline);
    List<LatLng> markersListCopy = [
      ...?store.state.mapData?.markerCoordinateList
    ];
    List<Map<Coordinate, String>> addressesListCopy = [
      ...?store.state.mapData?.addressesList
    ];
    Coordinate loadingKey = const Coordinate(latitude: 0, longitude: 0);
    String loadingValue = "loading";
    addressesListCopy.add({loadingKey: loadingValue});
    markersListCopy.add(marker);
    if (state.mapData!.markerCoordinateList.isEmpty) {
      return state.copy(
          mapData: state.mapData?.copyWith(
              markerCoordinateList: markersListCopy,
              addressesList: addressesListCopy));
    }
    return state.copy(
        mapData: state.mapData?.copyWith(
            markerCoordinateList: markersListCopy,
            polylineList: polylinesListCopy,
            addressesList: addressesListCopy));
  }
}

class MapActionAddressesManager extends ReduxAction<AppState> {
  Geocoding address;
  double duration;
  double distance;

  MapActionAddressesManager(
      this.address,
      this.duration,
      this.distance
      );

  @override
  AppState? reduce() {
    List<Map<Coordinate, String>> addressesListCopy = [
      ...?store.state.mapData?.addressesList
    ];
    Map<Coordinate, String> addressData = {};
    Coordinate coordinate = address.coordinate;
    String fullAddress =
        "${address.address.road} ${address.address.houseNumber} ${address.address.city == "" ? (address.address.district == "" ? "Unknown Station Name" : address.address.district) : address.address.city}"; // Value for the entry
    addressData[coordinate] = fullAddress;

    int emptyMapIndex = addressesListCopy
        .indexWhere((element) => element.containsValue("loading"));
    if (emptyMapIndex != -1) addressesListCopy[emptyMapIndex] = addressData;

    return state.copy(
        mapData: state.mapData?.copyWith(addressesList: addressesListCopy));
  }
}

class RemoveLastMarker extends ReduxAction<AppState> {
  int key;

  RemoveLastMarker(this.key);

  @override
  AppState? reduce() {
    List<List<LatLng>> polylinesListCopy = [
      ...?store.state.mapData?.polylineList
    ];
    List<LatLng> markersListCopy = [
      ...?store.state.mapData?.markerCoordinateList
    ];
    List<Map<Coordinate, String>> addressesListCopy = [
      ...?store.state.mapData?.addressesList
    ];

    markersListCopy.removeAt(key);
    addressesListCopy.removeLast();
    if (polylinesListCopy.isNotEmpty) polylinesListCopy.removeLast();
    return state.copy(
        mapData: state.mapData?.copyWith(
            markerCoordinateList: markersListCopy,
            polylineList: polylinesListCopy,
            addressesList: addressesListCopy));
  }
}
