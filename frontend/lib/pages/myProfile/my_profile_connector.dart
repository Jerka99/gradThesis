import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/navigation/navigation_action.dart';

import '../../app_state.dart';
import '../auth/auth_action.dart';
import 'my_profile.dart';

class MyProfileContainer extends StatelessWidget{

  const MyProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {

        return MyProfile(
            logOut: vm.logOut
        );},
    );
  }
}

class _ViewModel extends Vm{

  final Function() logOut;

  _ViewModel({
    required this.logOut
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        logOut: () {
          store.dispatch(LogOutAction());
        }
    );
  }
}
