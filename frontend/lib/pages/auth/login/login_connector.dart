import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/navigation/navigation_action.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';

import '../../../app_state.dart';
import '../auth_action.dart';
import 'login_page.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';

class Factory extends VmFactory<AppState, LoginConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
          onLogin: (AuthDto auth) {
            dispatch(LoginAction(authDto: auth));
          },
          routeChange: (path) {
            dispatch(MyNavigateAction(path));
            },
        authResponseHandler: state.authResponseHandler
      );
}


class ViewModel extends Vm{

  final Function(AuthDto) onLogin;
  Function(String) routeChange;
  AuthResponseHandler? authResponseHandler;

  ViewModel({
    required this.onLogin,
    required this.routeChange,
    required this.authResponseHandler
  });

  @override
  String toString() {
    return 'ViewModel{onLogin: $onLogin, routeChange: $routeChange, authResponseHandler: $authResponseHandler}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          onLogin == other.onLogin &&
          routeChange == other.routeChange &&
          authResponseHandler == other.authResponseHandler;

  @override
  int get hashCode =>
      super.hashCode ^
      onLogin.hashCode ^
      routeChange.hashCode ^
      authResponseHandler.hashCode;
}

class LoginConnector extends StatelessWidget{

  const LoginConnector({super.key});

@override
Widget build(BuildContext context) {

return StoreConnector<AppState, ViewModel>(
vm: () => Factory(),
builder: (BuildContext context, ViewModel vm) {
//this will prevent going back to login screen
  return LoginPage(
        onLogin: vm.onLogin,
        routeChange: vm.routeChange,
        authResponseHandler: vm.authResponseHandler
      );},
    );
  }
}
