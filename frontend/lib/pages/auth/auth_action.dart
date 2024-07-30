import 'package:async_redux/async_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:travel_mate/app_state.dart';
import 'package:travel_mate/mainApi.dart';
import 'package:travel_mate/model.dart';
import 'package:travel_mate/navigation/navigation_action.dart';
import 'package:travel_mate/pages/auth/TokenDto.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';

import '../../user_role.dart';

const storage = FlutterSecureStorage();

Future<void> storeToken(String token) async {
  await storage.write(key: 'jwt_token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'jwt_token');
}


class LoginAction extends ReduxAction<AppState>{
  AuthDto authDto;

  LoginAction(this.authDto);

  @override
  Future<AppState?> reduce() async {
    String? token = await getToken();

    if(JwtDecoder.isExpired(token!)) {
      await dispatch(GetTokenAction(authDto));
    } else {
      await dispatch(GetUserData(token));
    }
    return null;
  }
}


class GetTokenAction extends ReduxAction<AppState>{
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
      print('Login failed. Invalid credentials.');
    }
  }
}

class GetUserData extends ReduxAction<AppState>{
String token;

GetUserData(this.token);

@override
Future<AppState?> reduce() async {
  // if(email != "") store.dispatch(MyNavigateAction("/"));
  // return store.state.copy(user: state.user.copyWith(email: email, role: email == "customer" ? UserRole.customer : UserRole.driver));
  UserData? user = await MainApiClass().logIn(token);
  if (user != null) {
    // return store.state.user.copyWith(
    //   email: decodedToken[]
    // )
  } else {
    print('Login failed. Invalid credentials.');
  }
}
}

class RegisterAction extends ReduxAction<AppState>{
  String email;
  String password;
  String role;

  RegisterAction(
      this.email,
      this.password,
      this.role
      );

  @override
  AppState reduce() {
    if(email != "") store.dispatch(MyNavigateAction("/"));
    return store.state.copy(user: state.user.copyWith(email: email, role: userRoleFromJson(role)));
  }
}

