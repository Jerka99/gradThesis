import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/utils/app_routes.dart';

class MyRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  String? _currentRoute;
  Map<String, MaterialPage>? unsecuredPages;

  MyRouterDelegate({
    this.unsecuredPages,
  }): navigatorKey = GlobalKey<NavigatorState>();

  @override
  String? get currentConfiguration {
    return _currentRoute;
  }

  @override
  Widget build(BuildContext context) {
    List<MaterialPage> page = initPages();
    return Navigator(
      key: navigatorKey,
      pages: page,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        // Update the _loggedIn flag if you have a mechanism for tracking user authentication.
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    // This method should update the route based on the provided configuration.
    // You can parse the configuration to determine the new route path.
    // For simplicity, we'll just update the _loggedIn flag based on the path.

    _currentRoute=configuration;
    notifyListeners();
  }

  List<MaterialPage> initPages() {
    List<MaterialPage> pages = [];
    // Retrieve the page widgets based on the current route
    MaterialPage? pageWidget = unsecuredPages?[_currentRoute ?? "home"]!;
    pages.add(pageWidget!);
    return pages;
  }

  void myNavigate(String route){
    _currentRoute = route;
    notifyListeners();
  }

}
