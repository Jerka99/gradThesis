import 'package:flutter/material.dart';
import 'package:travel_mate/user_role.dart';
import '../functions/capitalize.dart';
import '../role_handler.dart';

class CustomBar extends StatefulWidget {
  final Function(String) routeChange;
  final String? route;
  final UserRole? userRole;

  const CustomBar({
    required this.routeChange,
    this.userRole,
    this.route,
    super.key,
  });

  @override
  State<CustomBar> createState() => _CustomBarState();
}

class _CustomBarState extends State<CustomBar> {
  late UserRole userRole;
  late Map<String, String> tabs;
  @override
  initState(){
    super.initState();
    tabs = {
      "/": widget.userRole == UserRole.customer ? "Desire ride" : "Create ride",
      "allRides": "All Rides",
      "myProfile": "My Profile"
    };
  }
  @override
  void didUpdateWidget(covariant CustomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    tabs = {
      "/": widget.userRole == UserRole.customer ? "Desire ride" : "Create ride",
      "allRides": "All Rides",
      "myProfile": "My Profile"
    };
  }
    int current = 0;

  double changePosition(width, String? route) {
    int index = tabs.keys.contains(route) ? tabs.keys.toList().indexOf(route!) : 0;
    switch (index) {
      case 0:
        return 0;
      case 1:
        return width * 1 / 3;
      case 2:
        return width * 2 / 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WidgetWithRole(
      role: widget.userRole,
      widgetName: "Bar",
      child: Column(
        children: [
          SizedBox(
            height: 53,
            child: Container(
              width: size.width,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "TravelMate",
                  style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
            ),
            height: 53,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Stack(
                children: [
                  Row(
                    children: tabs.keys.map((route) {
                      bool isSelected = route == widget.route;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.routeChange(route);
                            setState(() {
                              current = tabs.keys.toList().indexOf(route);
                            });
                          },
                          child: Container(
                            color: Colors.cyan[50],
                            child: Center(
                              child: Text(
                                capitalize(tabs[route]!),
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    left: changePosition(size.width, widget.route),
                    child: AnimatedOpacity(
                      opacity: 0.1,
                      duration: const Duration(milliseconds: 250),
                      child: Container(
                        color: Colors.blue,
                        width: size.width * 1 / 3,
                        height: size.height * 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
