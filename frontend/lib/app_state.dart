import 'package:platform_detector/platform_detector.dart';
import 'package:travel_mate/model.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';
import 'package:travel_mate/platform_dto.dart';
import 'myMap/map_data_class.dart';
import 'navigation/app_routes.dart';
import 'navigation/my_router_delegate.dart';

class AppState {
  final MyRouterDelegate routerDelegate;
  UserData user;
  String? route;
  MapData? mapData;
  DateTime dateTime;
  AuthResponseHandler? authResponseHandler;
  PlatformDto platformDto;

  AppState({
    required this.routerDelegate,
    required this.user,
    required this.route,
    required this.mapData,
    required this.dateTime,
    required this.authResponseHandler,
    required this.platformDto,
  });

  static AppState initialState() => AppState(
      routerDelegate: MyRouterDelegate(
          unsecuredPages: AppRoutes().unsecuredPages,
          securedPages: AppRoutes().securedPages),
      user: UserData.init(),
      route: null,
      mapData: MapData(),
      dateTime: DateTime.now(),
      authResponseHandler: AuthResponseHandler.init(),
      platformDto: PlatformDto(
        currentPlatformCompany: PlatformDetector.platform.company,
        currentPlatformName: PlatformDetector.platform.name,
        currentPlatformType: PlatformDetector.platform.type,
      ));

  AppState copy(
      {MyRouterDelegate? routerDelegate,
      UserData? user,
      String? route,
      MapData? mapData,
      DateTime? dateTime,
      AuthResponseHandler? authResponseHandler,
      PlatformDto? platformDto
      }) {
    return AppState(
        routerDelegate: routerDelegate ?? this.routerDelegate,
        user: user ?? this.user,
        route: route ?? this.route,
        mapData: mapData ?? this.mapData,
        dateTime: dateTime ?? this.dateTime,
        authResponseHandler: authResponseHandler ?? this.authResponseHandler,
        platformDto: platformDto ?? this.platformDto
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
          authResponseHandler == other.authResponseHandler &&
          platformDto == other.platformDto;

  @override
  int get hashCode =>
      routerDelegate.hashCode ^
      user.hashCode ^
      route.hashCode ^
      mapData.hashCode ^
      dateTime.hashCode ^
      authResponseHandler.hashCode ^
      platformDto.hashCode;

  DateTime setDateTime(AppState state) => state.dateTime.copyWith(
        year: dateTime.year,
        month: dateTime.month,
        hour: dateTime.hour,
        minute: dateTime.minute,
      )!;
}
