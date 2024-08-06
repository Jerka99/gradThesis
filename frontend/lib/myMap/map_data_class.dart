
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/myMap/address_class.dart';

class MapData{
  List<LatLng> markerCoordinateList;
  List<List<LatLng>> polylineList;
  List<AddressClass> addressesList;

  MapData({
    this.markerCoordinateList = const [],
    this.polylineList = const [],
    this.addressesList = const []
  });

  MapData copyWith({
    List<LatLng>? markerCoordinateList,
    List<List<LatLng>>? polylineList,
    List<AddressClass>? addressesList
  }){
    return MapData(
        markerCoordinateList: markerCoordinateList ?? this.markerCoordinateList,
        polylineList: polylineList ?? this.polylineList,
        addressesList: addressesList ?? this.addressesList)
    ;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapData &&
          runtimeType == other.runtimeType &&
          markerCoordinateList == other.markerCoordinateList &&
          polylineList == other.polylineList &&
          addressesList == other.addressesList;

  @override
  int get hashCode =>
      markerCoordinateList.hashCode ^
      polylineList.hashCode ^
      addressesList.hashCode;

  @override
  String toString() {
    return 'MapData{markerCoordinateList2: $markerCoordinateList, polylineList2: $polylineList, addressesList: $addressesList}';
  }

  factory MapData.fromJson(Map<String, dynamic> json) {
    var markerCoordinates = (json['markerCoordinateList'] as List)
        .map((item) => LatLng.fromJson(item))
        .toList();

    var addresses = (json['addressesList'] as List)
        .map((item) => AddressClass.fromJson(item))
        .toList();

    return MapData(
      markerCoordinateList: markerCoordinates,
      polylineList: [],
      addressesList: addresses,
    );
  }
}