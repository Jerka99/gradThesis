import 'package:redux_example/utils/app_routes.dart';
import 'package:redux_example/utils/my_router_delegate.dart';

class AppState {
   final MyRouterDelegate routerDelegate;
   int? counter;
   String? username;


  AppState({
     required this.routerDelegate,
     this.counter,
     this.username,
  });

  static AppState initialState() =>
    AppState(
    routerDelegate: MyRouterDelegate(unsecuredPages:AppRoutes()
      .unsecuredPages));

   @override
   bool operator ==(Object other) =>
       identical(this, other) ||
           other is AppState && runtimeType == other.runtimeType &&
               routerDelegate == other.routerDelegate;

   @override
   int get hashCode => routerDelegate.hashCode;

}
