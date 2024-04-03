import 'package:flutter/material.dart';
import 'package:redux_example/home/home_container.dart';
import 'package:redux_example/unknown/unknown_container.dart';

import '../login/login_container.dart';


class AppRoutes {

  final Map<String, MaterialPage> unsecuredPages = const {
    '/unknown': MaterialPage(child: UnknownContainer()),
    '/login': MaterialPage(child: LoginContainer()),
    '/': MaterialPage(child: HomeContainer())
  };
}


