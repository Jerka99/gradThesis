import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/navigation/navigation_action.dart';

import '../../app_state.dart';
import 'CustomBar.dart';

class CustomBarContainer extends StatelessWidget{

  String? route;
  String? userHasRole;

  CustomBarContainer({
    this.route,
    this.userHasRole,
    super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
//this will prevent going back to CustomBar screen
        return CustomBar(
            route: route,
            userHasRole: userHasRole,
            routeChange: vm.routeChange
        );},
    );
  }
}

class _ViewModel extends Vm{

  Function(String route) routeChange;

  _ViewModel({
    required this.routeChange
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        routeChange: (String route){ store.dispatch(MyNavigateAction(route));}
    );
  }
}
