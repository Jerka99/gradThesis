import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/navigation/navigation_action.dart';
import 'package:travel_mate/user_role.dart';

import '../../../app_state.dart';
import 'CustomBar.dart';

class Factory extends VmFactory<AppState, CustomBarConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
        route: state.route,
        userHasRole: state.user.role,
        routeChange: (String route){ dispatch(MyNavigateAction(route));},
      );
}

class ViewModel extends Vm{

  Function(String) routeChange;
  String? route;
  UserRole? userHasRole;

  ViewModel({
    required this.routeChange,
    this.userHasRole,
    this.route,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is ViewModel &&
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


class CustomBarConnector extends StatelessWidget{

  const CustomBarConnector({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
//this will prevent going back to CustomBar screen
        return CustomBar(
            route: vm.route,
            userHasRole: vm.userHasRole,
            routeChange: vm.routeChange
        );},
    );
  }
}

