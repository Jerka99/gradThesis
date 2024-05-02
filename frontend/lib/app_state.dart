import 'package:redux_example/model.dart';

import 'navigation/app_routes.dart';
import 'navigation/my_router_delegate.dart';

class AppState {
   final MyRouterDelegate routerDelegate;
   UserData user;
   String route;

  AppState({
     required this.routerDelegate,
     required this.user,
     required this.route
  });

  static AppState initialState() =>
    AppState(
     routerDelegate: MyRouterDelegate(
        unsecuredPages:AppRoutes().unsecuredPages,
        securedPages:AppRoutes().securedPages
     ),
      user: UserData(userName: null, email: null, role: null),
      route: "/"
    );

  AppState copy({
    MyRouterDelegate? routerDelegate,
    UserData? user,
    String? route
  }){
    return AppState(
        routerDelegate: routerDelegate ?? this.routerDelegate,
        user: user ?? this.user,
        route: route ?? this.route
    );
}

   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          routerDelegate == other.routerDelegate &&
          user == other.user &&
          route == other.route;

  @override
  int get hashCode => routerDelegate.hashCode ^ user.hashCode ^ route.hashCode;
}
