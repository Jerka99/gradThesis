import 'package:flutter/material.dart';

import '../pages/home/home_container.dart';
import '../pages/login/login_container.dart';
import '../pages/register/register_container.dart';
import '../pages/something/something_container.dart';
import '../pages/unknown/unknown_container.dart';



class AppRoutes {
  final Map<String, MaterialPage> unsecuredPages = const {
    'login': MaterialPage(child: LoginContainer()),
    'register': MaterialPage(child: RegisterContainer()),
  };

  final Map<String, MaterialPage> securedPages = const {
    '/': MaterialPage(child: HomeContainer()),
    'unknown': MaterialPage(child: UnknownContainer()),
    'something': MaterialPage(child: SomethingContainer()),
  };
}


