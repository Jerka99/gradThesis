import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/navigation/navigation_action.dart';

import '../../app_state.dart';
import 'Home.dart';

class HomeContainer extends StatelessWidget{

  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
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

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onNavigateToLogin: () {
        store.dispatch(MyNavigateAction("login"));
      }
    );
  }
}
