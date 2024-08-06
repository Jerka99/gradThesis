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
            dispatch(MyNavigateAction(path));
          },
          authResponseHandler: state.authResponseHandler,
          isInformed: state.authResponseHandler?.isInformed
      );
}

class ViewModel extends Vm{

  final Function(AuthDto) onRegister;
  Function(String) routeChange;
  final AuthResponseHandler? authResponseHandler;
  Event<bool>? isInformed;


  ViewModel({
    required this.onRegister,
    required this.routeChange,
    required this.authResponseHandler,
    required this.isInformed,
  });

  @override
  String toString() {
    return 'ViewModel{onRegister: $onRegister, routeChange: $routeChange, authResponseHandler: $authResponseHandler, isInformed: $isInformed}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          onRegister == other.onRegister &&
          routeChange == other.routeChange &&
          authResponseHandler == other.authResponseHandler &&
          isInformed == other.isInformed;

  @override
  int get hashCode =>
      super.hashCode ^
      onRegister.hashCode ^
      routeChange.hashCode ^
      authResponseHandler.hashCode ^
      isInformed.hashCode;
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
            authResponseHandler: vm.authResponseHandler,
            isInformed: vm.isInformed
        );},
    );
  }
}