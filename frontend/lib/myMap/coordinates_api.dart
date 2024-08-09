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

Future<ResponseData?> fetchCoordinates(startPoint, endPoint, callback) async {
  try {
    callback(true);
    var response = await http.post(Uri.parse(
        AppConstants.directionsUrl,
    ),
      body: '{"coordinates":[[$startPoint],[$endPoint]]}',
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
  } finally {
    callback(false);
  }
  return null;
}

List<AddressClass> endpointsToBeFetched = [];
bool isFetching = false;

Future<void> fetchAddressName(
    Coordinate endPoint,
    DataBetweenTwoAddresses dataBetweenTwoAddresses,
    bool boolean,
    void Function(AddressClass) callback,
    int stationNumber) async {
  if (boolean) {
    AddressClass coordinateAndData =
    AddressClass(coordinates: endPoint, fullAddress: null, city: null, dataBetweenTwoAddresses: dataBetweenTwoAddresses);
    endpointsToBeFetched.add(coordinateAndData);
  }

  if (!isFetching && endpointsToBeFetched.isNotEmpty) {
    isFetching = true;
    while (endpointsToBeFetched.isNotEmpty) {
      AddressClass firstElement = endpointsToBeFetched.first;
      try {
        await NominatimGeocoding.init();
        Geocoding address =
            await NominatimGeocoding.to.reverseGeoCoding(Coordinate(
          latitude: firstElement.coordinates!.latitude,
          longitude: firstElement.coordinates!.longitude,
        ));
        await createAddressObject(address, callback, firstElement, stationNumber);
      } catch (error) {
        print("error fetching location name");
        if (error.toString() ==
            "Expected a value of type 'Geocoding', but got one of type 'String'") {
          await createAddressObject(null, callback, firstElement, stationNumber);
        }
        if (error.toString() ==
            "Exception: can not sent more than 1 request per second") {
          print("Exception: can not sent more than 1 request per second");
          await Future.delayed(const Duration(milliseconds: 2000));
        }
      }
    }
    isFetching = false;
  }
}

Future<void> createAddressObject(address, callback, firstElement, stationNumber) async {
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

  AddressClass addressClass =
  AddressClass(fullAddress: fullAddress, city: cityOrDistrict, dataBetweenTwoAddresses: firstElement.dataBetweenTwoAddresses);
  endpointsToBeFetched.removeAt(0);
  callback(addressClass);
}
