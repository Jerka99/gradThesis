import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:travel_mate/constants.dart';
import 'package:travel_mate/myMap/address_class.dart';

class ResponseData {
  List<LatLng> coordinates;
  double distance;
  double duration;

  ResponseData(this.coordinates, this.distance, this.duration);
}

Future<ResponseData?> fetchCoordinates(markerCoordinateList) async {
  if(markerCoordinateList.length == 1){
    markerCoordinateList.add(markerCoordinateList[0]);
  }
  var jsonBody = jsonEncode({'coordinates': markerCoordinateList});
  try {
    var response = await http.post(Uri.parse(
        AppConstants.directionsUrl,
    ),
        body: jsonBody,
      headers: <String, String>{
        'Accept': 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': '${dotenv.env["API_KEY"]}',
      });

    var data = jsonDecode(response.body);

    if (data.containsKey("error") && data["error"]["code"] == 2010) {
      throw Exception(data["error"]["message"]);
    }
    // List<dynamic> coordinates = data["features"][0]["geometry"]["coordinates"];
    List<dynamic> coordinates = data["features"][0]["geometry"]["coordinates"];
    List<LatLng> coordinatesMapped = coordinates
        .map<LatLng>((element) => LatLng(element[1], element[0]))
        .toList();
    double distance =
        data["features"][0]["properties"]["segments"][0]["distance"] ?? 0;
    double duration =
        data["features"][0]["properties"]["segments"][0]["duration"] ?? 0;

    ResponseData responseData =
        ResponseData(coordinatesMapped, distance, duration);

    return responseData;
  } catch (e) {
    print("error -> $e");
  }
  return null;
}

List<LatLng> endpointsToBeFetched = [];
List<AddressClass> addressesList = [];
bool isFetching = false;

Future<void> fetchAddressName(
    LatLng markerCoordinate,
    stationNumber,
    callback
) async {
      try {
        await NominatimGeocoding.init();
        Geocoding address =
            await NominatimGeocoding.to.reverseGeoCoding(Coordinate(
          latitude: markerCoordinate.latitude,
          longitude: markerCoordinate.longitude,
        ));
         await createAddressObject(address, stationNumber, callback);

      } catch (error) {
        print("error fetching location name");
        if (error.toString() ==
            "Expected a value of type 'Geocoding', but got one of type 'String'") {
            await createAddressObject(null, stationNumber, callback);
        }
        if (error.toString() ==
            "Exception: can not sent more than 1 request per second") {
          print("Exception: can not sent more than 1 request per second");
          await Future.delayed(const Duration(milliseconds: 2000));
          fetchAddressName(markerCoordinate, stationNumber, callback);
        }
      }
}

Future<void> createAddressObject(address, stationNumber, callback) async {
  String fullAddress = address != null
      ? address?.address.road == "" ? "Station $stationNumber" : "${address?.address.road} ${address?.address.houseNumber}"
      : "No data for this country";
  String? cityOrDistrict = address?.address.city == null
      ? null
      : address.address.city == ""
          ? (address.address.district == ""
              ? "Unknown Station Name"
              : address.address.district)
          : address.address.city;

  AddressClass newAddress =
  AddressClass(fullAddress: fullAddress, city: cityOrDistrict);
  callback(newAddress);
}
