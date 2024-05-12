import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/navigation/navigation_action.dart';

import '../../../app_state.dart';
import '../auth_action.dart';
import 'LoginPage.dart';


class LoginContainer extends StatelessWidget{

  const LoginContainer({super.key});

@override
Widget build(BuildContext context) {

return StoreConnector<AppState, _ViewModel>(
converter: (Store<AppState> store) => _ViewModel.fromStore(store),
builder: (BuildContext context, _ViewModel vm) {
//this will prevent going back to login screen
  return LoginPage(
        onLogin: vm.onLogin,
        routeChange: vm.routeChange
      );},
    );
  }
}

class _ViewModel extends Vm{

  final Function(Map<String, dynamic>) onLogin;
  Function(String) routeChange;

  _ViewModel({
      required this.onLogin,
      required this.routeChange
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        onLogin: (Map<String, dynamic> auth) {
          store.dispatch(LoginAction(auth["email"], auth["password"]));
        },
        routeChange: (path){ store.dispatch(MyNavigateAction(path));}
    );
  }
}
