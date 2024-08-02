import 'package:async_redux/async_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:travel_mate/app_state.dart';
import 'package:travel_mate/main_api.dart';
import 'package:travel_mate/model.dart';
import 'package:travel_mate/navigation/navigation_action.dart';
import 'package:travel_mate/pages/auth/TokenDto.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';

const storage = FlutterSecureStorage();

Future<void> storeToken(String token) async {
  await storage.write(key: 'jwt_token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'jwt_token');
}

class LoginAction extends ReduxAction<AppState> {
  AuthDto? authDto;

  LoginAction({this.authDto});

  @override
  Future<AppState?> reduce() async {
    String? token = await getToken();

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
      await storeToken(token);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final tokenData = TokenDto.fromJson(decodedToken);
      print(decodedToken);
    } else {
      return state.copy(
          responseHandler:
              ResponseHandler(detail: "Login failed. Invalid credentials."));
    }
  }
}

class GetUserData extends ReduxAction<AppState> {
  String token;

  GetUserData(this.token);

  @override
  Future<AppState?> reduce() async {
    // if(email != "") store.dispatch(MyNavigateAction("/"));
    // return store.state.copy(user: state.user.copyWith(email: email, role: email == "customer" ? UserRole.customer : UserRole.driver));
    UserData? user = await MainApiClass().logIn(token);
    if (user != null) {
      dispatch(MyNavigateAction("/"));
      return store.state.copy(user: user);
    } else {
      return store.state.copy(
          responseHandler:
              ResponseHandler(description: "Login failed. Invalid credentials."));
    }
  }
}

class RegisterAction extends ReduxAction<AppState> {
  AuthDto authDto;

  RegisterAction(this.authDto);

  @override
  Future<AppState?> reduce() async {
    ResponseHandler response = await MainApiClass().register(authDto);

    return state.copy(responseHandler: response);
  }
}
