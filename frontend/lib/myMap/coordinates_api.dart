import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/constants.dart';

class ResponseData{
  List<LatLng> coordinates;
  double distance;
  double duration;

  ResponseData(
      this.coordinates,
      this.distance,
      this.duration
      );
}


Future<ResponseData?> fetchCoordinates(startPoint, endPoint, callback)
async {
try{
  callback(true);
  var response = await http.get(Uri.parse("${AppConstants.directionsUrl}?api_key=${dotenv
      .env["API_KEY"]}&start=$startPoint&end=$endPoint"));

    var data = jsonDecode(response.body);

  List<dynamic> coordinates = data["features"][0]["geometry"]["coordinates"];
  List<LatLng> coordinatesMapped = coordinates
      .map<LatLng>((element) => LatLng(element[1], element[0]))
      .toList();
  double distance = data["features"][0]["properties"]["summary"]["distance"] ?? 0;
  double duration = data["features"][0]["properties"]["summary"]["duration"] ?? 0;

  ResponseData responseData = ResponseData(coordinatesMapped, distance, duration);

  return responseData;
  }
catch(e){
  print("error -> $e");
}
finally{
  callback(false);
}
  return null;
}


Future<void> fetchAddressName(endPoint, callbackFun) async {
  Geocoding address;
  try {
    await NominatimGeocoding.init();
    double lng = double.parse(endPoint.split(",")[0]);
    double lat = double.parse(endPoint.split(",")[1]);

    address = await NominatimGeocoding.to.reverseGeoCoding(
        Coordinate(
          latitude: lat, longitude: lng,
        ));
    address ?? "unknown";
    callbackFun(address);
  }
  catch(e){
    print("error2 -> $e");
    if(e.toString() == "Exception: can not sent more than 1 request per second") {
      Future.delayed(const Duration(microseconds: 1000), () {
        print("Calling my own function after 1 second");
        fetchAddressName(endPoint, callbackFun);
      });
    }
  }
}