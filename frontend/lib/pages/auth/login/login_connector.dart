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
        responseHandler: state.responseHandler
      );
}


class ViewModel extends Vm{

  final Function(AuthDto) onLogin;
  Function(String) routeChange;
  ResponseHandler? responseHandler;

  ViewModel({
    required this.onLogin,
    required this.routeChange,
    required this.responseHandler
  });

  @override
  String toString() {
    return 'ViewModel{onLogin: $onLogin, routeChange: $routeChange, responseHandler: $responseHandler}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          onLogin == other.onLogin &&
          routeChange == other.routeChange &&
          responseHandler == other.responseHandler;

  @override
  int get hashCode =>
      super.hashCode ^
      onLogin.hashCode ^
      routeChange.hashCode ^
      responseHandler.hashCode;
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
        responseHandler: vm.responseHandler
      );},
    );
  }
}
