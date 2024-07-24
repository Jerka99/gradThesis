import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:travel_mate/constants.dart';
import 'package:http/http.dart' as http;

import 'myMap/address_class.dart';

class MainApiClass{

  Future logIn() async {
    // const String url;
    // final Response<Map<String, dynamic>> response =
    // await client.get(environment.appServerUrl + url);
    // return MarketingConsent.fromJson(response.data as Map<String, dynamic>);
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