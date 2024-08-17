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
  ResponseHandler? responseHandler;
  PlatformDto platformDto;
  AllRidesList allRidesList;
  LatLng? currentUserLocation;
  int? selectedId;

  AppState({
    required this.routerDelegate,
    required this.user,
    required this.route,
    required this.mapData,
    required this.dateTime,
    required this.responseHandler,
    required this.platformDto,
    required this.allRidesList,
    required this.currentUserLocation,
    required this.selectedId,
  });

  static AppState initialState() => AppState(
      routerDelegate: MyRouterDelegate(
          unsecuredPages: AppRoutes().unsecuredPages,
          securedPages: AppRoutes().securedPages),
      user: UserData.init(),
      route: null,
      mapData: MapData(),
      dateTime: DateTime.now(),
      responseHandler: ResponseHandler.init(),
      platformDto: PlatformDto(
        currentPlatformCompany: PlatformDetector.platform.company,
        currentPlatformName: PlatformDetector.platform.name,
        currentPlatformType: PlatformDetector.platform.type,
      ),
      allRidesList: AllRidesList.init(),
      currentUserLocation: null,
      selectedId: null
  );

  AppState copy(
      {MyRouterDelegate? routerDelegate,
      UserData? user,
      String? route,
      MapData? mapData,
      DateTime? dateTime,
      ResponseHandler? responseHandler,
      PlatformDto? platformDto,
      AllRidesList? allRidesList,
      LatLng? currentUserLocation,
      int? selectedId
      }) {
    return AppState(
        routerDelegate: routerDelegate ?? this.routerDelegate,
        user: user ?? this.user,
        route: route ?? this.route,
        mapData: mapData ?? this.mapData,
        dateTime: dateTime ?? this.dateTime,
        responseHandler: responseHandler ?? this.responseHandler,
        platformDto: platformDto ?? this.platformDto,
        allRidesList: allRidesList ?? this.allRidesList,
        currentUserLocation: currentUserLocation ?? this.currentUserLocation,
        selectedId: selectedId ?? this.selectedId,
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
          responseHandler == other.responseHandler &&
          platformDto == other.platformDto &&
          allRidesList == other.allRidesList &&
          currentUserLocation == other.currentUserLocation &&
          selectedId == other.selectedId;

  @override
  int get hashCode =>
      routerDelegate.hashCode ^
      user.hashCode ^
      route.hashCode ^
      mapData.hashCode ^
      dateTime.hashCode ^
      responseHandler.hashCode ^
      platformDto.hashCode ^
      allRidesList.hashCode ^
      currentUserLocation.hashCode ^
      selectedId.hashCode;


  @override
  String toString() {
    return 'AppState{routerDelegate: $routerDelegate, user: $user, route: $route, mapData: $mapData, dateTime: $dateTime, responseHandler: $responseHandler, platformDto: $platformDto, allRidesList: $allRidesList, currentUserLocation: $currentUserLocation, selectedId: $selectedId}';
  }

  DateTime setDateTime(AppState state) => state.dateTime.copyWith(
        year: dateTime.year,
        month: dateTime.month,
        hour: dateTime.hour,
        minute: dateTime.minute,
      );
}
