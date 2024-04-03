import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/unknown/Unknown.dart';

import '../app_state.dart';
import '../utils/my_router_delegate.dart';

class UnknownContainer extends StatelessWidget{

  const UnknownContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store, Provider
          .of<MyRouterDelegate>(context, listen: false)),
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

  static _ViewModel fromStore(Store<AppState> store, MyRouterDelegate myRouterDelegate) {
    return _ViewModel(
        onReturn: () {
          myRouterDelegate.myNavigate("/");
        }
    );
  }
}
