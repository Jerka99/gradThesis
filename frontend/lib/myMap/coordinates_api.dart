import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/constants.dart';
import 'package:redux_example/myMap/address_class.dart';

class ResponseData {
  List<LatLng> coordinates;
  double distance;
  double duration;

  ResponseData(this.coordinates, this.distance, this.duration);
}

Future<ResponseData?> fetchCoordinates(startPoint, endPoint, callback) async {
  try {
    callback(true);
    var response = await http.get(Uri.parse(
        "${AppConstants.directionsUrl}?api_key=${dotenv.env["API_KEY"]}&start=$startPoint&end=$endPoint"));

    var data = jsonDecode(response.body);

    if (data.containsKey("error") && data["error"]["code"] == 2010) {
      throw Exception(data["error"]["message"]);
    }
    List<dynamic> coordinates = data["features"][0]["geometry"]["coordinates"];
    List<LatLng> coordinatesMapped = coordinates
        .map<LatLng>((element) => LatLng(element[1], element[0]))
        .toList();
    double distance =
        data["features"][0]["properties"]["summary"]["distance"] ?? 0;
    double duration =
        data["features"][0]["properties"]["summary"]["duration"] ?? 0;

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

Future<void> fetchAddressName(Coordinate endPoint, DataBetweenTwoAddresses dataBetweenTwoAddresses, bool boolean, void Function(AddressClass) callback) async {
  if (boolean) {
    AddressClass coordinateAndData = AddressClass(endPoint, null, null, dataBetweenTwoAddresses);
    endpointsToBeFetched.add(coordinateAndData);
  }

  if (!isFetching && endpointsToBeFetched.isNotEmpty) {
    isFetching = true;
    while (endpointsToBeFetched.isNotEmpty) {
      AddressClass firstElement = endpointsToBeFetched.first;
      try {
        await NominatimGeocoding.init();
        Geocoding address = await NominatimGeocoding.to.reverseGeoCoding(Coordinate(
          latitude: firstElement.coordinate.latitude,
          longitude: firstElement.coordinate.longitude,
        ));

        Coordinate coordinate = address.coordinate;
        String fullAddress = "${address.address.road} ${address.address.houseNumber}";
        String cityOrDistrict = address.address.city == ""
            ? (address.address.district == "" ? "Unknown Station Name" : address.address.district)
            : address.address.city;

        AddressClass addressClass = AddressClass(coordinate, fullAddress, cityOrDistrict, firstElement.dataBetweenTwoAddresses);
        endpointsToBeFetched.removeAt(0);
        callback(addressClass);
        await Future.delayed(const Duration(milliseconds: 2000));

      } catch (error) {
        print("object");
        if (error.toString() == "Exception: can not sent more than 1 request per second") {
          fetchAddressName(endPoint, dataBetweenTwoAddresses, false, callback);
        }
      }
    }
    isFetching = false;
  }
}

