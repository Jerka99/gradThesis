import 'package:travel_mate/model.dart';
import 'package:travel_mate/user_role.dart';

import 'myMap/map_data_class.dart';
import 'navigation/app_routes.dart';
import 'navigation/my_router_delegate.dart';

class AppState {
   final MyRouterDelegate routerDelegate;
   UserData user;
   String? route;
   MapData? mapData;

  AppState({
     required this.routerDelegate,
     required this.user,
    required this.route,
    required this.mapData
  });

  static AppState initialState() =>
    AppState(
     routerDelegate: MyRouterDelegate(
        unsecuredPages:AppRoutes().unsecuredPages,
        securedPages:AppRoutes().securedPages
     ),
      user: UserData(userName: null, email: null, role: userRoleFromJson(null)),
      route: null,
      mapData: MapData()
    );

  AppState copy({
    MyRouterDelegate? routerDelegate,
    UserData? user,
    String? route,
    MapData? mapData
  }){
    return AppState(
        routerDelegate: routerDelegate ?? this.routerDelegate,
        user: user ?? this.user,
        route: route ?? this.route,
        mapData: mapData ?? this.mapData,
    );
}

   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          routerDelegate == other.routerDelegate &&
          user == other.user &&
          route == other.route &&
          mapData == other.mapData;

  @override
  int get hashCode =>
      routerDelegate.hashCode ^
      user.hashCode ^
      route.hashCode ^
      mapData.hashCode;
}
