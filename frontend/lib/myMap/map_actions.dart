import 'package:async_redux/async_redux.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:travel_mate/app_state.dart';
import 'package:travel_mate/myMap/address_class.dart';

import '../mainApi.dart';
import 'coordinates_api.dart';

class InitFetch extends ReduxAction<AppState> {
  static String? startPoint;
  static String? endPoint;
  LatLng latLng;
  bool loading = false;
  String? tempStartPoint;
  String? tempEndPoint;

  InitFetch({
    required this.latLng
});

  void handleApiPath() {
    List<LatLng> markerCoordinateList = store.state.mapData!.markerCoordinateList;

    if (!loading) {

      if (markerCoordinateList.isEmpty) {
        startPoint = "${latLng.longitude}, ${latLng.latitude}";
        endPoint = startPoint;
      } else {
        LatLng lastMarker = markerCoordinateList[markerCoordinateList.length - 1];
        tempStartPoint = startPoint; //no wrong polylines if we re clicking on the sea
        tempEndPoint = endPoint;
        startPoint = "${lastMarker.longitude}, ${lastMarker.latitude}"; //?? startPoint
        endPoint = "${latLng.longitude}, ${latLng.latitude}";
      }
    }
  }

  @override
  Future<AppState?> reduce() async {
    ResponseData? coordinatesResponse;
    handleApiPath();
      coordinatesResponse = await fetchCoordinates(startPoint, endPoint, (bool value) => {loading = value});

      if (coordinatesResponse != null && coordinatesResponse.coordinates.isNotEmpty) {
      LatLng? lastElement = coordinatesResponse.coordinates[coordinatesResponse.coordinates.length-1];

      Coordinate lastElementCoordinates = Coordinate(latitude: lastElement!.latitude, longitude: lastElement.longitude);
      DataBetweenTwoAddresses dataBetweenTwoAddresses = DataBetweenTwoAddresses(coordinatesResponse!.duration, coordinatesResponse.distance);


        dispatch(MapActionAddMarkerAndPolyline(lastElement, coordinatesResponse.coordinates, coordinatesResponse.duration, coordinatesResponse.distance));
        await fetchAddressName(lastElementCoordinates, dataBetweenTwoAddresses, true, (address) => dispatch(MapActionAddressesManager(address)));

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
  double duration;
  double distance;

  MapActionAddMarkerAndPolyline(
      this.marker,
      this.polyline,
      this.duration,
      this.distance,
  );

  @override
  AppState? reduce() {
    List<List<LatLng>> polylinesListCopy = [
      ...?store.state.mapData?.polylineList
    ];
    polylinesListCopy.add(polyline);
    List<LatLng> markersListCopy = [
      ...?store.state.mapData?.markerCoordinateList
    ];
    List<AddressClass> addressesListCopy = [
      ...?store.state.mapData?.addressesList
    ];

    Coordinate latLng = Coordinate(latitude: marker.latitude, longitude: marker.longitude);
    DataBetweenTwoAddresses dataBetweenTwoAddresses = DataBetweenTwoAddresses(duration, distance);

    addressesListCopy.add(AddressClass(latLng, "loading", "loading", dataBetweenTwoAddresses));
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
  AddressClass address;

  MapActionAddressesManager(
      this.address,
      );

  @override
  Future<AppState?> reduce() async{

    List<AddressClass> addressesListCopy = [
      ...?store.state.mapData?.addressesList
    ];

    int emptyMapIndex = addressesListCopy
        .indexWhere((element) => element.city == "loading");
    if (emptyMapIndex != -1) addressesListCopy[emptyMapIndex] = address;

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
    List<AddressClass> addressesListCopy = [
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

class SaveMapData extends ReduxAction<AppState> {

  SaveMapData();

  @override
  AppState? reduce() {
    MainApiClass().saveMapData(
      state.mapData!.addressesList,
      state.mapData!.markerCoordinateList
    );

  }
}