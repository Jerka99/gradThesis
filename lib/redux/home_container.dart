import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/Home.dart';
import 'package:redux_example/LoginPage.dart';
import 'package:redux_example/globals.dart';

import '../app_state.dart';
import '../utils/my_router_delegate.dart';

class HomeContainer extends StatelessWidget{

  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store, Provider
          .of<MyRouterDelegate>(context, listen: false)),
      builder: (BuildContext context, _ViewModel vm) {
//this will prevent going back to login screen
        return HomePage(
            onNavigateToLogin: vm.onNavigateToLogin
        );},
    );
  }
}

class _ViewModel extends Vm{

  final Function() onNavigateToLogin;

  _ViewModel({
    required this.onNavigateToLogin
  });

  static _ViewModel fromStore(Store<AppState> store, MyRouterDelegate myRouterDelegate) {
    return _ViewModel(
      onNavigateToLogin: () {
        myRouterDelegate.myNavigate("login");
      }
    );
  }
}
