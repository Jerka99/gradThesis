import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/login/LoginPage.dart';
import 'package:redux_example/login/login_action.dart';

import '../app_state.dart';

class LoginContainer extends StatelessWidget{

  const LoginContainer({super.key});

@override
Widget build(BuildContext context) {

return StoreConnector<AppState, _ViewModel>(
converter: (Store<AppState> store) => _ViewModel.fromStore(store),
builder: (BuildContext context, _ViewModel vm) {
//this will prevent going back to login screen
return LoginPage(
onLogin: vm.onLogin
      );},
    );
  }
}

class _ViewModel extends Vm{

  final Function(String, String) onLogin;

  _ViewModel({
      required this.onLogin
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        onLogin: (String email, String password) {
          store.dispatch(LoginAction(email, password));
        },
    );
  }
}
