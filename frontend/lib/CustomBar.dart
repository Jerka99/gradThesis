import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "functions/capitalize.dart";

import 'app_state.dart';

class CustomBar extends StatefulWidget {

  final Function(String) routeChange;
  String? route;
  String? userHasRole;

  CustomBar({
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
    "something": "something",
    "unknown": "unknown"
  };
  int current = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
         SizedBox(
           child: Container(
             height: size.height * 0.06,
             width: size.width,
             color: Colors.blue,
             child: const Center(child: Text(
                 "MY APP",
               style: TextStyle(fontSize: 20.0),
             )),
           ),
         ),
        widget.userHasRole != null && widget.userHasRole != "" ? SizedBox(
            height: size.height * 0.06,
            child: ListView.builder(
            itemCount: tabs.length,
            scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder:
              (context, index) => GestureDetector(
                onTap: (){
                  setState(() {
                    widget.routeChange(tabs.keys.toList()[index] as String);
                  });
                },
                child: Container(
                  color: Colors.cyan[50],
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.333,
                    child: Center(
                      child: Text(
                          capitalize(tabs.values.toList()[index]),
                          style: TextStyle(
                            fontWeight: tabs.keys.toList()[index] == widget.route ?
                            FontWeight.bold : FontWeight.normal,
                            fontSize: 20.0
                          ),
                      ),
                    ),
                  ),
                ),
              )
          )
        ) : SizedBox(
          height: size.height * 0.06,
          child: Container(
            color: Colors.cyan[50],
          ),
        ),
      ],
    );
  }
}
