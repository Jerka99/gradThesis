import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/utils/my_route_information_parser.dart';
import 'package:redux_example/utils/my_router_delegate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MyRouterDelegate _routerDelegate = MyRouterDelegate();
  final MyRouteInformationParser _routeInformationParser =
  MyRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}
