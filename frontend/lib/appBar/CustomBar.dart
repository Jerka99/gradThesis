import 'package:flutter/material.dart';
import 'package:travel_mate/user_role.dart';
import '../functions/capitalize.dart';
import '../role_handler.dart';

class CustomBar extends StatefulWidget {
  final Function(String) routeChange;
  final String? route;
  final UserRole? userHasRole;

  const CustomBar({
    required this.routeChange,
    this.userHasRole,
    this.route,
    super.key,
  });

  @override
  State<CustomBar> createState() => _CustomBarState();
}

class _CustomBarState extends State<CustomBar> {
  Map<String, String> tabs = {
    "/": "home",
    "allRides": "All Rides",
    "myProfile": "My Profile"
  };
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
      role: widget.userHasRole,
      widgetName: "Bar",
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.06,
            child: Container(
              width: size.width,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "MY APP",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
            ),
            height: size.height * 0.06,
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
