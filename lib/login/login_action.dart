import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:redux_example/app_state.dart';
import 'package:redux_example/model.dart';

import '../redux/actions.dart';

class LoginAction extends Action{
  String email;
  String password;

  LoginAction(
    this.email,
    this.password
);

  @override
  AppState reduce() {
    if(this.email != "") store.state.routerDelegate.myNavigate("/");
    return store.state.copy(user: state.user.copyWith(email: email));
  }
}

