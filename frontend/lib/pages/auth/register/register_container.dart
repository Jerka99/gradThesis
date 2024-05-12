import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/navigation/navigation_action.dart';
import 'package:redux_example/pages/auth/register/registerPage.dart';
import 'package:redux_example/user_role.dart';

import '../../../app_state.dart';
import '../auth_action.dart';

class RegisterContainer extends StatelessWidget{

  UserRole role;

  RegisterContainer({
    required this.role,
    super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
//this will prevent going back to Register screen
        return RegisterPage(
            onRegister: vm.onRegister,
            routeChange: vm.routeChange,
            role: role
        );},
    );
  }
}

class _ViewModel extends Vm{

  final Function(Map<String, dynamic> x) onRegister;
  Function(String) routeChange;

  _ViewModel({
    required this.onRegister,
    required this.routeChange
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onRegister: (Map<String, dynamic> x) {
        store.dispatch(RegisterAction(x["email"], x["password"], x["role"]));
      },
        routeChange: (path){ store.dispatch(MyNavigateAction(path));}
    );
  }
}
