import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/navigation/navigation_action.dart';

import '../../app_state.dart';
import 'SomethingPage.dart';

class SomethingContainer extends StatelessWidget{

  const SomethingContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
//this will prevent going back to login screen
        return SomethingPage(
            onSomething: vm.onSomething
        );},
    );
  }
}

class _ViewModel extends Vm{

  final Function(String, String) onSomething;

  _ViewModel({
    required this.onSomething
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onSomething: (String username, String otp) {
        store.dispatch(MyNavigateAction("something"));
      },
    );
  }
}
