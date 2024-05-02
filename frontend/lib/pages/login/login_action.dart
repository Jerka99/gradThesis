
import 'package:async_redux/async_redux.dart';
import 'package:redux_example/app_state.dart';
import 'package:redux_example/navigation/navigation_action.dart';


class LoginAction extends ReduxAction<AppState>{
  String email;
  String password;

  LoginAction(
    this.email,
    this.password
);

  @override
  AppState reduce() {
    if(email != "") store.dispatch(MyNavigateAction("/"));
    return store.state.copy(user: state.user.copyWith(email: email, role:
    email));
  }
}

