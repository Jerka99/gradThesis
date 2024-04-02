import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/LoginPage.dart';
import 'package:redux_example/utils/app_routes.dart';

import '../app_state.dart';
import '../utils/my_router_delegate.dart';

class LoginContainer extends StatelessWidget{

  const LoginContainer({super.key});

@override
Widget build(BuildContext context) {

return StoreConnector<AppState, _ViewModel>(
converter: (Store<AppState> store) => _ViewModel.fromStore(store, Provider
    .of<MyRouterDelegate>(context, listen: false)),
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
  final MyRouterDelegate routerDelegate;

  _ViewModel({
      required this.routerDelegate,
      required this.onLogin
  });

  static _ViewModel fromStore(Store<AppState> store, MyRouterDelegate myRouterDelegate) {
    return _ViewModel(
        onLogin: (String username, String otp) {
          myRouterDelegate.myNavigate("/");
        },
      routerDelegate: myRouterDelegate,
    );
  }
}
