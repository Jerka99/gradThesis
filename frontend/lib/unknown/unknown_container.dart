import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/unknown/Unknown.dart';

import '../app_state.dart';

class UnknownContainer extends StatelessWidget{

  const UnknownContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {

        return Unknown(
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
          store.state.routerDelegate.myNavigate("/");
        }
    );
  }
}
