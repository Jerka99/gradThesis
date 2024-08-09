import 'package:latlong2/latlong.dart';
import 'package:platform_detector/platform_detector.dart';
import 'package:travel_mate/model.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';
import 'package:travel_mate/platform_dto.dart';
import 'myMap/map_data_class.dart';
import 'myMap/all_rides_list.dart';
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
  AllRidesList allRidesList;
  LatLng? currentUserLocation;

  AppState({
    required this.routerDelegate,
    required this.user,
    required this.route,
    required this.mapData,
    required this.dateTime,
    required this.authResponseHandler,
    required this.platformDto,
    required this.allRidesList,
    required this.currentUserLocation,
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
      ),
      allRidesList: AllRidesList.init(),
      currentUserLocation: null,
  );

  AppState copy(
      {MyRouterDelegate? routerDelegate,
      UserData? user,
      String? route,
      MapData? mapData,
      DateTime? dateTime,
      AuthResponseHandler? authResponseHandler,
      PlatformDto? platformDto,
      AllRidesList? allRidesList,
      LatLng? currentUserLocation
      }) {
    return AppState(
        routerDelegate: routerDelegate ?? this.routerDelegate,
        user: user ?? this.user,
        route: route ?? this.route,
        mapData: mapData ?? this.mapData,
        dateTime: dateTime ?? this.dateTime,
        authResponseHandler: authResponseHandler ?? this.authResponseHandler,
        platformDto: platformDto ?? this.platformDto,
        allRidesList: allRidesList ?? this.allRidesList,
        currentUserLocation: currentUserLocation ?? this.currentUserLocation,
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
          platformDto == other.platformDto &&
          allRidesList == other.allRidesList &&
          currentUserLocation == other.currentUserLocation;

  @override
  int get hashCode =>
      routerDelegate.hashCode ^
      user.hashCode ^
      route.hashCode ^
      mapData.hashCode ^
      dateTime.hashCode ^
      authResponseHandler.hashCode ^
      platformDto.hashCode ^
      allRidesList.hashCode ^
      currentUserLocation.hashCode;


  @override
  String toString() {
    return 'AppState{routerDelegate: $routerDelegate, user: $user, route: $route, mapData: $mapData, dateTime: $dateTime, authResponseHandler: $authResponseHandler, platformDto: $platformDto, allRidesList: $allRidesList, currentUserLocation: $currentUserLocation}';
  }

  DateTime setDateTime(AppState state) => state.dateTime.copyWith(
        year: dateTime.year,
        month: dateTime.month,
        hour: dateTime.hour,
        minute: dateTime.minute,
      );
}
