import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/register/registerPage.dart';

import '../app_state.dart';

class RegisterContainer extends StatelessWidget{

  const RegisterContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
//this will prevent going back to Register screen
        return RegisterPage(
            onRegister: vm.onRegister
        );},
    );
  }
}

class _ViewModel extends Vm{

  final Function(String, String) onRegister;

  _ViewModel({
    required this.onRegister
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onRegister: (String username, String otp) {
        store.state.routerDelegate.myNavigate("something");
      },
    );
  }
}
