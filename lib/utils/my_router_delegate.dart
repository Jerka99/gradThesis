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
    // When using browsers backward/forward button setNewRoutePath is called.
    // You can parse the configuration to determine the new route path.
  if(unsecuredPages!.containsKey(configuration) || configuration == "/") {
    _currentRoute = configuration;
  } else {
    _currentRoute = "/unknown";
  }

    notifyListeners();
  }

  List<MaterialPage> initPages() {
    List<MaterialPage> pages = [];
    MaterialPage? pageWidget = unsecuredPages?[_currentRoute ?? "/"]!;
    pages.add(pageWidget!);
    return pages;
  }

  void myNavigate(String route){
    _currentRoute = route;
    notifyListeners();
  }

}
