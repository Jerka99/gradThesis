import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/navigation/navigation_action.dart';

import '../../../app_state.dart';
import '../auth_action.dart';
import 'LoginPage.dart';

class Factory extends VmFactory<AppState, LoginConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
          onLogin: (Map<String, dynamic> auth) {
            dispatch(LoginAction(auth["email"], auth["password"]));
          },
          routeChange: (path){dispatch(MyNavigateAction(path));}
      );
}


class ViewModel extends Vm{

  final Function(Map<String, dynamic>) onLogin;
  Function(String) routeChange;

  ViewModel({
    required this.onLogin,
    required this.routeChange
  });
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
        routeChange: vm.routeChange
      );},
    );
  }
}
