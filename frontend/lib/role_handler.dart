import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_mate/user_role.dart';

class WidgetWithRole extends StatefulWidget {

  UserRole? role;
  String widgetName;
  Widget child;

   WidgetWithRole({
     this.role,
     required this.widgetName,
     required this.child,
     super.key
   });

  @override
  State<WidgetWithRole> createState() => _WidgetWithRole();
}

class _WidgetWithRole extends State<WidgetWithRole> {

  Map<String, Widget> driverWidgetsList = {
    "Bar": const SizedBox.shrink(),
    "Map": const SizedBox.shrink(),
  };

  bool get isAllowed => widget.role == UserRole.customer || widget.role == UserRole.driver;

  @override
  Widget build(BuildContext context) {
    if(isAllowed) {
      return widget.child;
    }
    return driverWidgetsList[widget.widgetName]!;
  }
}
