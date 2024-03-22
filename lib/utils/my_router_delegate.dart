import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Home.dart';
import '../LoginPage.dart';

class MyRouterDelegate extends RouterDelegate<RouteInformation>
    with ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  RouteInformation get currentConfiguration {
    if (_loggedIn) {
      return RouteInformation(uri: Uri.parse('/login'));
    } else {
      return RouteInformation(uri: Uri.parse('/home'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(child: HomePage(onNavigateToLogin: _navigateToLogin)),
        if (_loggedIn) MaterialPage(child: LoginPage(onLogin: _login)),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        // Update the _loggedIn flag if you have a mechanism for tracking user authentication.
        _loggedIn = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteInformation configuration) async {}

  bool _loggedIn = false;

  void _navigateToLogin() {
    _loggedIn = true;
    notifyListeners();
  }

  void _login() {
    _loggedIn = false;
    notifyListeners();
  }

  @override
  Future<bool> popRoute() {
    //need this for enabling browsers backward button if popRoute isnt overriden
    // PopNavigatorRouterDelegateMixin<RouteInformation>
    // Handle the back button press here
    if (_loggedIn) {
      _loggedIn = false;
      notifyListeners();
      return SynchronousFuture<bool>(true);
    }
    return SynchronousFuture<bool>(false);
  }

}