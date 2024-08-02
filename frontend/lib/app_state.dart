import 'package:travel_mate/model.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';
import 'package:travel_mate/user_role.dart';
import 'myMap/map_data_class.dart';
import 'navigation/app_routes.dart';
import 'navigation/my_router_delegate.dart';

class AppState {
  final MyRouterDelegate routerDelegate;
  UserData user;
  String? route;
  MapData? mapData;
  DateTime dateTime;
  ResponseHandler? responseHandler;

  AppState({
    required this.routerDelegate,
    required this.user,
    required this.route,
    required this.mapData,
    required this.dateTime,
    required this.responseHandler,
  });

  static AppState initialState() =>
      AppState(
          routerDelegate: MyRouterDelegate(
              unsecuredPages: AppRoutes().unsecuredPages,
              securedPages: AppRoutes().securedPages
          ),
          user: UserData(
              name: null, email: null, role: userRoleFromJson(null)),
          route: null,
          mapData: MapData(),
          dateTime: DateTime.now(),
          responseHandler: ResponseHandler.init(),
      );

  AppState copy({
    MyRouterDelegate? routerDelegate,
    UserData? user,
    String? route,
    MapData? mapData,
    DateTime? dateTime,
    ResponseHandler? responseHandler
  }) {
    return AppState(
      routerDelegate: routerDelegate ?? this.routerDelegate,
      user: user ?? this.user,
      route: route ?? this.route,
      mapData: mapData ?? this.mapData,
      dateTime: dateTime ?? this.dateTime,
      responseHandler: responseHandler ?? this.responseHandler
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
          mapData == other.mapData &&
          dateTime == other.dateTime &&
          responseHandler == other.responseHandler;

  @override
  int get hashCode =>
      routerDelegate.hashCode ^
      user.hashCode ^
      route.hashCode ^
      mapData.hashCode ^
      dateTime.hashCode ^
      responseHandler.hashCode;

  DateTime setDateTime(AppState state) => state.dateTime.copyWith(
    year: dateTime.year,
    month: dateTime.month,
    hour: dateTime.hour,
    minute: dateTime.minute,
  )!;

}