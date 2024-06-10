import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/navigation/navigation_action.dart';

import '../../app_state.dart';
import 'my_profile.dart';

class MyProfileContainer extends StatelessWidget{

  const MyProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {

        return MyProfile(
            onReturn: vm.onReturn
        );},
    );
  }
}

class _ViewModel extends Vm{

  final Function() onReturn;

  _ViewModel({
    required this.onReturn
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        onReturn: () {
          store.dispatch(MyNavigateAction("/"));
        }
    );
  }
}
