import 'dart:ui';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/app_state.dart';
import 'package:redux_example/navigation/navigation_action.dart';

class MyRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  String? _currentRoute;
  Map<String, MaterialPage>? unsecuredPages;
  Map<String, MaterialPage>? securedPages;

  MyRouterDelegate({
    this.unsecuredPages,
    this.securedPages
  }): navigatorKey = GlobalKey<NavigatorState>();

  @override
  String? get currentConfiguration {
    return _currentRoute;
  }

  @override
  Widget build(BuildContext context) {
    AppState? state = StoreProvider.state<AppState>(context);
    print(state);
    List<MaterialPage> page = initPages(state?.user.email);
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
    // When using browsers backward/forward buttons and on initial app start
    // setNewRoutePath is called.
    // You can parse the configuration to determine the new route path.
    final BuildContext context = navigatorKey.currentContext!;
    AppState? state = StoreProvider.state<AppState>(context);
    if(state?.user.email != null) {
      _currentRoute = securedPages?.keys.firstWhere((k) =>
      k == configuration,
          orElse: () => _currentRoute as String);
    }
    else {
      var route = unsecuredPages?.keys.firstWhere((k) =>
      k == configuration,
          orElse: () => securedPages!.containsKey(configuration) ? "login" : _currentRoute as
          String);
      _currentRoute = route;
    }
    StoreProvider.dispatch<AppState>(context, MyNavigateAction(_currentRoute!));

    notifyListeners();
  }

  List<MaterialPage> initPages(email) {
    List<MaterialPage> pages = [];
    MaterialPage? pageWidget;
    if(email == null || email == "") {
      pageWidget = unsecuredPages?[unsecuredPages
        !.containsKey(_currentRoute) ? _currentRoute : "login"]!;
    } else {
      pageWidget = securedPages?[_currentRoute ?? "/"]!;
    }
    print(pageWidget);
    pages.add(pageWidget!);
    return pages;
  }

  void myNavigate(String route){
    final BuildContext context = navigatorKey.currentContext!;
    _currentRoute = route;
    notifyListeners();
  }

}
