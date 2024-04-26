import 'package:flutter/material.dart';
import 'package:redux_example/home/home_container.dart';
import 'package:redux_example/unknown/unknown_container.dart';

import '../login/login_container.dart';
import '../register/register_container.dart';
import '../something/something_container.dart';


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


