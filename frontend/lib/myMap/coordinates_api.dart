import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux_example/constants.dart';


Future<List<dynamic>?> handleCoordinatesCall(startPoint, endPoint, callback)
async {
try{
  callback(true);
  var response = await http.get(Uri.parse("${AppConstants.directionsUrl}?api_key=${dotenv
      .env["API_KEY"]}&start=$startPoint&end=$endPoint"));
    var data = jsonDecode(response.body);
    List<dynamic> coordinates = data["features"][0]["geometry"]["coordinates"];
    return coordinates;
  }
catch(e){
  print(e);
}
finally{
  callback(false);
}
  return [];
}
