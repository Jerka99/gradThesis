import 'dart:convert';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/constants.dart';
import 'package:http/http.dart' as http;
import 'package:travel_mate/model.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';

import 'myMap/address_class.dart';

class MainApiClass{

  Future<String?> getToken(AuthDto authDto) async {
    Response response = await http.post(Uri.parse("${AppConstants.backendUrl}/auth/login"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(authDto.toJson()));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData["token"];
    } else {
      // Handle errors
      var responseData = jsonDecode(response.body);
      print('Failed to login. Status code: ${response.statusCode}');
      return null;
    }
  }

  Future<UserData?> logIn(token) async {
    Response response = await http.get(Uri.parse("${AppConstants.backendUrl}/users/me"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer $token'
        },
    );

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      UserData userData = UserData.fromJson(decoded);
      return userData;
    } else {
      // Handle errors
      var responseData = jsonDecode(response.body);
      print('Failed to login. Status code: ${response.statusCode}');
      return null;
    }
  }


  Future register() async {
    // const String url;
    // final Response<Map<String, dynamic>> response =
    // await client.get(environment.appServerUrl + url);
    // return MarketingConsent.fromJson(response.data as Map<String, dynamic>);
  }

  Future fetchAllRides() async {
    // const String url;
    // final Response<Map<String, dynamic>> response =
    // await client.get(environment.appServerUrl + url);
    // return MarketingConsent.fromJson(response.data as Map<String, dynamic>);
  }


  Future saveMapData(List<AddressClass> addressesList, List<LatLng> markerCoordinateList) async {
    const String url = AppConstants.backendUrl;
    return http.post(
      Uri.parse('url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'addressesList': addressesList,
        'markerCoordinateList': markerCoordinateList,
      }),
    );

    // final Response<Map<String, dynamic>> response =
    // await client.get(environment.appServerUrl + url);
    // return MarketingConsent.fromJson(response.data as Map<String, dynamic>);
  }

}