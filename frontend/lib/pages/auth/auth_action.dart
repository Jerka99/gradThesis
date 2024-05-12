
import 'package:async_redux/async_redux.dart';
import 'package:redux_example/app_state.dart';
import 'package:redux_example/navigation/navigation_action.dart';

import '../../user_role.dart';


class LoginAction extends ReduxAction<AppState>{
  String email;
  String password;

  LoginAction(
      this.email,
      this.password,
      );

  @override
  AppState reduce() {
    if(email != "") store.dispatch(MyNavigateAction("/"));
    return store.state.copy(user: state.user.copyWith(email: email, role: UserRole.customer));
  }
}

class RegisterAction extends ReduxAction<AppState>{
  String email;
  String password;
  String role;

  RegisterAction(
      this.email,
      this.password,
      this.role
      );

  @override
  AppState reduce() {
    if(email != "") store.dispatch(MyNavigateAction("/"));
    return store.state.copy(user: state.user.copyWith(email: email, role:
    userRoleFromJson(role)));
  }
}

