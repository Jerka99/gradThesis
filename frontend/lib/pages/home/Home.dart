import 'package:flutter/material.dart';
import 'package:travel_mate/main.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/pages/display/from_to_display.dart';
import 'package:travel_mate/role_handler.dart';
import 'package:travel_mate/user_role.dart';
import 'package:travel_mate/myMap/map_connector.dart';

class HomePage extends StatefulWidget {
  List<AddressClass> addressesList;
  UserRole? role;
  final Function(AddressClass) addAddress;
  final DateTime? dateTime;
  Function() fetchLocation;

  HomePage({
    super.key,
    required this.addressesList,
    this.role,
    required this.addAddress,
    this.dateTime,
    required this.fetchLocation
  });

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController controller;
  late DateTime? dateTime;

  @override
  void initState() {
    super.initState();
    widget.fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  height: constraint.minHeight,
                  constraints: const BoxConstraints(
                    minHeight: 700.0,
                  ),
                  width: double.maxFinite,
                  child: Column(children: [
                    Expanded(
                      child: WidgetWithRole(
                          role: UserRole.customer,
                          widgetName: "Map",
                          child: MapConnector(
                            role: widget.role,
                          )),
                    ),
                    SizedBox(
                      child: Container(
                        height: 10,
                      ),
                    ),
                    Expanded(
                      child: FromToDisplay(
                        addressesList: widget.addressesList,
                        dateTime: widget.dateTime,
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
