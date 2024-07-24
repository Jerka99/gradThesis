import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

class DataBetweenTwoAddresses{
  double duration;
  double distance;

  DataBetweenTwoAddresses(this.duration, this.distance);
}

class AddressClass{
  Coordinate? coordinate;
  String? fullAddress;
  String? city;
  DataBetweenTwoAddresses? dataBetweenTwoAddresses;

  AddressClass(
      this.coordinate,
      this.fullAddress,
      this.city,
      this.dataBetweenTwoAddresses,
      );
}