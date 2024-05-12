import 'package:flutter/material.dart';

import '../pages/auth/login/login_container.dart';
import '../pages/auth/register/register_container.dart';
import '../pages/home/home_container.dart';
import '../pages/something/something_container.dart';
import '../pages/unknown/unknown_container.dart';
import '../user_role.dart';



class AppRoutes {
  final Map<String, MaterialPage> unsecuredPages = {
    'login': const MaterialPage(child: LoginContainer()),
    'registerDriver': MaterialPage(child: RegisterContainer(role: UserRole.driver)),
    'registerCustomer': MaterialPage(child: RegisterContainer(role: UserRole.customer,)),
  };

  final Map<String, MaterialPage> securedPages = const {
    '/': MaterialPage(child: HomeContainer()),
    'unknown': MaterialPage(child: UnknownContainer()),
    'something': MaterialPage(child: SomethingContainer()),
  };
}


