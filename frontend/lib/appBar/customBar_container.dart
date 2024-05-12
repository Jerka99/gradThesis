import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_example/navigation/navigation_action.dart';
import 'package:redux_example/user_role.dart';

import '../../../app_state.dart';
import 'CustomBar.dart';

class CustomBarContainer extends StatelessWidget{

  const CustomBarContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
//this will prevent going back to CustomBar screen
        return CustomBar(
            route: vm.route,
            userHasRole: vm.userHasRole,
            routeChange: vm.routeChange
        );},
    );
  }
}

class _ViewModel extends Vm{

  Function(String) routeChange;
  String? route;
  UserRole? userHasRole;

  _ViewModel({
    required this.routeChange,
    this.userHasRole,
    this.route,
  });


  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        route: store.state.route,
        userHasRole: store.state.user.role,
        routeChange: (String route){ store.dispatch(MyNavigateAction(route));},
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is _ViewModel &&
          runtimeType == other.runtimeType &&
          routeChange == other.routeChange &&
          route == other.route &&
          userHasRole == other.userHasRole;

  @override
  int get hashCode =>
      super.hashCode ^
      routeChange.hashCode ^
      route.hashCode ^
      userHasRole.hashCode;
}
