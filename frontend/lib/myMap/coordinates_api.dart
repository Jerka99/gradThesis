import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/constants.dart';


Future<List<dynamic>?> handleCoordinatesCall(startPoint, endPoint, callback)
async {
try{
  callback(true);
  var response = await http.get(Uri.parse("${AppConstants.directionsUrl}?api_key=${dotenv
      .env["API_KEY"]}&start=$startPoint&end=$endPoint"));

    var data = jsonDecode(response.body);
    // if(data["key"])
    List<dynamic> coordinates = data["features"][0]["geometry"]["coordinates"];

  return coordinates;
  }
catch(e){
  print("error -> $e");
}
finally{
  callback(false);
}
  return [];
}


Future<void> handleAddressName(endPoint, callbackFun) async {
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
      Future.delayed(const Duration(seconds: 1), () {
        print("Calling my own function after 1 second");
        handleAddressName(endPoint, callbackFun);
      });
    }
  }
}