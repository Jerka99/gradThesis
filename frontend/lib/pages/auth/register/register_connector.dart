import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/navigation/navigation_action.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';
import 'package:travel_mate/pages/auth/register/register_page.dart';
import 'package:travel_mate/user_role.dart';

import '../../../app_state.dart';
import '../auth_action.dart';
import '../response_handler_dto.dart';

class Factory extends VmFactory<AppState, RegisterConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
          onRegister: (AuthDto authDto) {
            dispatch(RegisterAction(authDto));
          },
          routeChange: (path){
            dispatch(MyNavigateAction(route: path!));
          },
          responseHandler: state.responseHandler,
      );
}

class ViewModel extends Vm{

  final Function(AuthDto) onRegister;
  Function(String) routeChange;
  final ResponseHandler? responseHandler;


  ViewModel({
    required this.onRegister,
    required this.routeChange,
    required this.responseHandler,
  });

  @override
  String toString() {
    return 'ViewModel{onRegister: $onRegister, routeChange: $routeChange, responseHandler: $responseHandler}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          onRegister == other.onRegister &&
          routeChange == other.routeChange &&
          responseHandler == other.responseHandler;

  @override
  int get hashCode =>
      super.hashCode ^
      onRegister.hashCode ^
      routeChange.hashCode ^
      responseHandler.hashCode;
}


class RegisterConnector extends StatelessWidget{

  UserRole role;

  RegisterConnector({
    required this.role,
    super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return RegisterPage(
            onRegister: vm.onRegister,
            routeChange: vm.routeChange,
            role: role,
            responseHandler: vm.responseHandler,
        );},
    );
  }
}