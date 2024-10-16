import 'dart:convert';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/StoreSecurity.dart';
import 'package:travel_mate/constants.dart';
import 'package:http/http.dart' as http;
import 'package:travel_mate/model.dart';
import 'package:travel_mate/myMap/map_data_class.dart';
import 'package:travel_mate/myMap/personal_rides_list.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';
import 'myMap/address_class.dart';

class MainApiClass {

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

  Future<ResponseHandler?> logIn(token) async {
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
      return ResponseHandler(data: userData);
    } else {
      return ResponseHandler(message: "Login failed. Invalid credentials.");
    }
  }


  Future<ResponseHandler>? register(AuthDto authDto) async {
    Response response = await http.post(
        Uri.parse("${AppConstants.backendUrl}/auth/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(authDto.toJson()));

    if (response.statusCode == 200) {
      return ResponseHandler(message: response.body);
    } else {
      return ResponseHandler.fromJson(jsonDecode(response.body));
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

  Future<List<PersonalRide>> fetchPersonalRidesByDriver() async {
    String? token = await StoreSecurity().getToken();

    Response response = await http.get(Uri.parse(
        "${AppConstants.backendUrl}/fetchPersonalRidesForDriver"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
    List<PersonalRide> personalDataList = [];
    if (response.statusCode == 200) {
      List<dynamic> decoded = jsonDecode(response.body);
      for (var element in decoded) {
        PersonalRide newRide = PersonalRide.fromJson(element);
        personalDataList.add(newRide);
      }
    }
    return personalDataList;
  }

  Future<List<PersonalRide>> fetchPersonalRidesByCustomer() async {
    String? token = await StoreSecurity().getToken();

    Response response = await http.get(Uri.parse(
        "${AppConstants.backendUrl}/fetchPersonalRidesForCustomer"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
    List<PersonalRide> personalDataList = [];
    if (response.statusCode == 200) {
      List<dynamic> decoded = jsonDecode(response.body);
      for (var element in decoded) {
        PersonalRide newRide = PersonalRide.fromJson(element);
        personalDataList.add(newRide);
      }
    }
    return personalDataList;
  }

  Future saveRideData(List<AddressClass> addressesList,
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

  Future saveDesiredRideData(List<AddressClass> addressesList,
      List<LatLng> markerCoordinateList) async {
    String? token = await StoreSecurity().getToken();

    Response response = await http.post(Uri.parse(
        "${AppConstants.backendUrl}/saveDesiredRideData"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'addressesList': addressesList,
          'markerCoordinateList': markerCoordinateList,
        }));
    if(response.statusCode == 200) {
      return response.body;
    }
    return null;
  }


  Future<dynamic> saveUserRoute(int rideId, List<int> sequence) async {
    String? token = await StoreSecurity().getToken();

    Response response = await http.post(Uri.parse(
        "${AppConstants.backendUrl}/saveUserRoute"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'rideId': rideId,
          'sequence': sequence,
        }));
    if(response.statusCode == 200) {
      return ResponseHandler(message: response.body, status: response.statusCode);
    }
    else{
      ResponseHandler responseHandler = ResponseHandler.fromJson(jsonDecode(response.body));
      return responseHandler;
    }
  }

  Future<dynamic> deleteUserRoute(int rideId) async {
    String? token = await StoreSecurity().getToken();

    Response response = await http.post(Uri.parse(
        "${AppConstants.backendUrl}/deleteUserRoute"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'rideId': rideId,
        }));
    if(response.statusCode == 200) {
      return ResponseHandler(message: response.body, status: response.statusCode);
    }
    else{
      ResponseHandler responseHandler = ResponseHandler.fromJson(jsonDecode(response.body));
      return responseHandler;
    }
  }

  Future<dynamic> deleteRideCreatedByDriver(int rideId) async {
    String? token = await StoreSecurity().getToken();

    Response response = await http.post(Uri.parse(
        "${AppConstants.backendUrl}/deleteRideCreatedByDriver"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'rideId': rideId,
        }));
    if(response.statusCode == 200) {
      return ResponseHandler(message: response.body, status: response.statusCode);
    }
    else{
      ResponseHandler responseHandler = ResponseHandler.fromJson(jsonDecode(response.body));
      return responseHandler;
    }
  }
}
