import 'package:flutter/material.dart';
import 'package:travel_mate/pages/auth/login/login_connector.dart';
import 'package:travel_mate/pages/auth/register/register_connector.dart';
import 'package:travel_mate/pages/allRides//all_rides_connector.dart';
import 'package:travel_mate/pages/myProfile/my_profile_connector.dart';

import '../pages/home/home_connector.dart';
import '../user_role.dart';



class AppRoutes {
  final Map<String, MaterialPage> unsecuredPages = {
    'login': const MaterialPage(child: LoginConnector()),
    'registerDriver': MaterialPage(child: RegisterConnector(role: UserRole.driver)),
    'registerCustomer': MaterialPage(child: RegisterConnector(role: UserRole.customer,)),
  };

  final Map<String, MaterialPage> securedPages = const {
    '/': MaterialPage(child: HomeConnector()),
    'myProfile': MaterialPage(child: MyProfileContainer()),
    'allRides': MaterialPage(child: AllRidesConnector()),
  };
}


