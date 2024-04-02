import 'package:flutter/material.dart';
import 'package:redux_example/redux/home_container.dart';

import '../redux/login_container.dart';


class AppRoutes {

  final Map<String, MaterialPage> unsecuredPages = const {
    // 'unknown': MaterialPage(child: HomePage(myNavigate: (String ) { },)),
    'login': MaterialPage(child: LoginContainer()),
    '/': MaterialPage(child: HomeContainer())
  };
}


