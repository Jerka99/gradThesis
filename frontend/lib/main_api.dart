import 'dart:convert';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/StoreSecurity.dart';
import 'package:travel_mate/constants.dart';
import 'package:http/http.dart' as http;
import 'package:travel_mate/model.dart';
import 'package:travel_mate/myMap/map_data_class.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';
import 'myMap/address_class.dart';

class MainApiClass {

  Future<String?> getToken(AuthDto authDto) async {
    Response response = await http.post(
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
          'Content-Type': 'application/json',
        },
        body: jsonEncode(authDto.toJson()));

    if (response.statusCode == 200) {
      return AuthResponseHandler(message: response.body);
    } else {
      return AuthResponseHandler.fromJson(jsonDecode(response.body));
    }
  }

  Future<MapData?> fetchAllRides() async {
    String? token = await StoreSecurity().getToken();

    Response response = await http.get(Uri.parse(
        "${AppConstants.backendUrl}/fetchAllRides"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      List<dynamic> decoded = jsonDecode(response.body);
      List<MapData> mapDataList = [];
      decoded.forEach((element) {
        mapDataList.add(MapData.fromJson(element));
      });

      return null;
    } else {
      return null;
    }
  }

  Future saveMapData(List<AddressClass> addressesList,
      List<LatLng> markerCoordinateList) async {
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
        }));
  }
}
