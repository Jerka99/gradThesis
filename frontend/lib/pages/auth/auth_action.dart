import 'package:async_redux/async_redux.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:travel_mate/app_state.dart';
import 'package:travel_mate/main.dart';
import 'package:travel_mate/main_api.dart';
import 'package:travel_mate/model.dart';
import 'package:travel_mate/navigation/navigation_action.dart';
import 'package:travel_mate/pages/auth/TokenDto.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';
import 'package:travel_mate/StoreSecurity.dart';
import 'package:travel_mate/myMap/all_rides_list.dart';
import 'package:travel_mate/myMap/map_data_class.dart';

class LoginAction extends ReduxAction<AppState> {
  AuthDto? authDto;

  LoginAction({this.authDto});

  @override
  Future<AppState?> reduce() async {
    String? token = await StoreSecurity().getToken();

    if (authDto == null && token != null && !JwtDecoder.isExpired(token)) {
      await dispatch(GetUserData(token));
    } else if (authDto != null) {
      await dispatch(GetTokenAction(authDto!));
    }
    return null;
  }
}

class GetTokenAction extends ReduxAction<AppState> {
  AuthDto authDto;

  GetTokenAction(this.authDto);

  @override
  Future<AppState?> reduce() async {
    // if(email != "") store.dispatch(MyNavigateAction("/"));
    // return store.state.copy(user: state.user.copyWith(email: email, role: email == "customer" ? UserRole.customer : UserRole.driver));
    String? token = await MainApiClass().getToken(authDto);
    if (token != null) {
      dispatch(GetUserData(token));
      await StoreSecurity().storeToken(token);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final tokenData = TokenDto.fromJson(decodedToken);
      print(decodedToken);
    } else {
      return state.copy(
          responseHandler:
              ResponseHandler(message: "Login failed. Invalid credentials."));
    }
  }
}

class GetUserData extends ReduxAction<AppState> {
  String token;

  GetUserData(this.token);

  @override
  Future<AppState?> reduce() async {
    ResponseHandler? responseHandler = await MainApiClass().logIn(token);
    if (responseHandler?.data != null) {
      dispatch(MyNavigateAction(route: "/"));
      return store.state.copy(user: responseHandler!.data);
    } else {
      return store.state.copy(
          responseHandler: responseHandler);
    }
  }
}

class RegisterAction extends ReduxAction<AppState> {
  AuthDto authDto;

  RegisterAction(this.authDto);

  @override
  Future<AppState?> reduce() async {
    ResponseHandler? response = await MainApiClass().register(authDto);

    if(response?.message == "Successfully Registered") {
      appViewportKey.currentState?.informUser(response?.message);
      dispatch(MyNavigateAction(route: "login"));
    }
    return state.copy(
        responseHandler: state.responseHandler?.copyWith(
            message: response?.message),);
  }
}

class LogOutAction extends ReduxAction<AppState> {
  LogOutAction();

  @override
  Future<AppState?> reduce() async {
    StoreSecurity().deleteToken();
    dispatch(MyNavigateAction(route: "login"));
    return state.copy(
      user: UserData.init(),
      route: null,
      mapData: MapData(),
      dateTime: DateTime.now(),
      responseHandler: ResponseHandler.init(),
      allRidesList: AllRidesList.init(),
    );
  }
}
