import 'dart:convert';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:platform_detector/enums.dart';
import 'package:travel_mate/StoreSecurity.dart';
import 'package:travel_mate/constants.dart';
import 'package:http/http.dart' as http;
import 'package:travel_mate/model.dart';
import 'package:travel_mate/myMap/coordinates_api.dart';
import 'package:travel_mate/myMap/map_data_class.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';
import 'package:travel_mate/platform_dto.dart';
import 'myMap/address_class.dart';

class MainApiClass {
  // static late PlatformDto platformDto; // Define static variable
  //
  // static void initializePlatform(PlatformDto platform) {
  //   platformDto = platform;
  // }

  Future<String?> getToken(AuthDto authDto) async {
    Response response;
    try {
      response = await http.post(
          Uri.parse("${AppConstants.backendUrl}/auth/login"),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(authDto.toJson()));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData["token"];
      } else {
        print('Failed to login. Status code: ${response.statusCode}');
        return null;
      }
    }catch(e){
      print(e);
    }

  }

  Future<AuthResponseHandler?> logIn(token) async {
    Response response = await http.get(
      Uri.parse("${AppConstants.backendUrl}/users/me"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      UserData userData = UserData.fromJson(decoded);
      return AuthResponseHandler(userData: userData);
    } else {
      return AuthResponseHandler(message: "Login failed. Invalid credentials.");
    }
  }


  Future<AuthResponseHandler>? register(AuthDto authDto) async {
    Response response = await http.post(
        Uri.parse("${AppConstants.backendUrl}/auth/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(authDto.toJson()));

    if (response.statusCode == 200) {
      return AuthResponseHandler(message: response.body);
    } else {
      return AuthResponseHandler.fromJson(jsonDecode(response.body));
    }
  }

  Future<List<MapData>> fetchAllRides() async {
    String? token = await StoreSecurity().getToken();

    Response response = await http.get(Uri.parse(
        "${AppConstants.backendUrl}/fetchAllRides"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
    List<MapData> mapDataList = [];
    if (response.statusCode == 200) {
      List<dynamic> decoded = jsonDecode(response.body);
      for (var element in decoded) {
        MapData newRide = MapData.fromJson(element);
        mapDataList.add(newRide);
      }
    }
    return mapDataList;
  }

  Future saveMapData(List<AddressClass> addressesList,
      List<LatLng> markerCoordinateList, double maxCapacity) async {
    String? token = await StoreSecurity().getToken();

    Response response = await http.post(Uri.parse(
        "${AppConstants.backendUrl}/saveRideData"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'addressesList': addressesList,
          'markerCoordinateList': markerCoordinateList,
          'maxCapacity': maxCapacity,
        }));
    if(response.statusCode == 200) {
      return response.body;
    }
    return null;
  }
}
