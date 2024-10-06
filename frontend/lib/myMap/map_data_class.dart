
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/myMap/address_class.dart';

class MapData{
  List<LatLng> markerCoordinateList;
  List<LatLng> polylineList;
  List<AddressClass> addressesList;
  double maxCapacity;
  int rideId;
  int? selectedMarkerIndex1;
  int? selectedMarkerIndex2;
  int? createdBy;

  MapData({
    this.markerCoordinateList = const [],
    this.polylineList = const [],
    this.addressesList = const [],
    this.maxCapacity = 0,
    this.rideId = 0,
    this.selectedMarkerIndex1,
    this.selectedMarkerIndex2,
    this.createdBy,
  });

  MapData copyWith({
    List<LatLng>? markerCoordinateList,
    List<LatLng>? polylineList,
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
          addressesList == other.addressesList &&
          maxCapacity == other.maxCapacity &&
          rideId == other.rideId &&
          selectedMarkerIndex1 == other.selectedMarkerIndex1 &&
          selectedMarkerIndex2 == other.selectedMarkerIndex2 &&
          createdBy == other.createdBy;

  @override
  int get hashCode =>
      markerCoordinateList.hashCode ^
      polylineList.hashCode ^
      addressesList.hashCode ^
      maxCapacity.hashCode ^
      rideId.hashCode ^
      selectedMarkerIndex1.hashCode ^
      selectedMarkerIndex2.hashCode ^
      createdBy.hashCode;

  @override
  String toString() {
    return 'MapData{markerCoordinateList2: $markerCoordinateList, polylineList2: $polylineList, addressesList: $addressesList maxCapacity: $maxCapacity rideId: $rideId, selectedMarkerIndex1 $selectedMarkerIndex1, selectedMarkerIndex2 $selectedMarkerIndex2, createdBy $createdBy}';
  }

  MapData.fromJson(Map<String, dynamic> json)
      : markerCoordinateList = (json['markerCoordinateList'] as List).map((item) => LatLng.fromJson(item)).toList(),
        polylineList = [],
        addressesList = (json['addressesList'] as List).map((item) => AddressClass.fromJson(item)).toList(),
        maxCapacity = (json['maxCapacity'] as double),
        rideId = (json['rideId'] as int),
        selectedMarkerIndex1 = (json['selectedMarkerIndex1'] as int?),
        selectedMarkerIndex2 = (json['selectedMarkerIndex2'] as int?),
        createdBy = (json['createdBy'] as int?);
}