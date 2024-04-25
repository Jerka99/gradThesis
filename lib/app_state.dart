import 'package:redux_example/model.dart';

import 'navigation/app_routes.dart';
import 'navigation/my_router_delegate.dart';

class AppState {
   final MyRouterDelegate routerDelegate;
   UserData user;


  AppState({
     required this.routerDelegate,
     required this.user,
  });

  static AppState initialState() =>
    AppState(
    routerDelegate: MyRouterDelegate(
        unsecuredPages:AppRoutes().unsecuredPages,
        securedPages:AppRoutes().securedPages
    ),
      user: UserData(userName: null, email: null, role: null)
    );

  AppState copy({
    MyRouterDelegate? routerDelegate,
    UserData? user,
  }){
    return AppState(
    routerDelegate: routerDelegate ?? this.routerDelegate,
    user: user ?? this.user);
}

   @override
   bool operator == (Object other) =>
       identical(this, other) ||
           other is AppState &&
               runtimeType == other.runtimeType &&
               routerDelegate == other.routerDelegate;

   @override
   int get hashCode => routerDelegate.hashCode;

   @override
  String toString() {
    return 'AppState{routerDelegate: $routerDelegate}';
  }
}
