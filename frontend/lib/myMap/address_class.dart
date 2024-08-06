import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

class DataBetweenTwoAddresses{
  double duration;
  double distance;

  DataBetweenTwoAddresses(this.duration, this.distance);

  Map<String, dynamic> toJson() => {
    'duration': duration,
    'distance': distance,
  };

  DataBetweenTwoAddresses.fromJson(Map<String, dynamic> json)
      : duration = json['duration'] as double,
        distance = json['distance'] as double;
}

class AddressClass{
  Coordinate? coordinates;
  String? fullAddress;
  String? city;
  DataBetweenTwoAddresses? dataBetweenTwoAddresses;

  AddressClass({
    this.coordinates,
    this.fullAddress,
    this.city,
    this.dataBetweenTwoAddresses,
  });

  Map<String, dynamic> toJson() => {
    'coordinates': coordinates,
    'fullAddress': fullAddress,
    'city': city,
    'dataBetweenTwoAddresses': dataBetweenTwoAddresses,
  };

  AddressClass.fromJson(Map<String, dynamic> json)
      : fullAddress = json['fullAddress'] as String?,
        city = json['city'] as String?,
        dataBetweenTwoAddresses = DataBetweenTwoAddresses.fromJson(json['dataBetweenTwoAddresses']);
}