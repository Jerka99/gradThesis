import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/navigation/navigation_action.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';
import 'package:travel_mate/pages/auth/register/register_page.dart';
import 'package:travel_mate/user_role.dart';

import '../../../app_state.dart';
import '../auth_action.dart';

class Factory extends VmFactory<AppState, RegisterConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
          onRegister: (AuthDto authDto) {
            dispatch(RegisterAction(authDto));
          },
          routeChange: (path){dispatch(MyNavigateAction(path));}
      );
}

class ViewModel extends Vm{

  final Function(AuthDto) onRegister;
  Function(String) routeChange;

  ViewModel({
    required this.onRegister,
    required this.routeChange
  });
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
//this will prevent going back to Register screen
        return RegisterPage(
            onRegister: vm.onRegister,
            routeChange: vm.routeChange,
            role: role
        );},
    );
  }
}