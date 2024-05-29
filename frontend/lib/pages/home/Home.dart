import 'package:flutter/material.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/role_handler.dart';
import 'package:redux_example/user_role.dart';

import '../../myMap/map_connector.dart';

class HomePage extends StatefulWidget {
  List<Map<Coordinate, String>> addressesList;
  UserRole? role;

  HomePage({
    super.key,
    required this.addressesList,
    this.role,
  });

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    // controller = AnimationController(
    //   /// [AnimationController]s can be created with `vsync: this` because of
    //   /// [TickerProviderStateMixin].
    //   vsync: this,
    //   duration: const Duration(seconds: 1),
    // );
    // controller.repeat(reverse: false);
    super.initState();
  }

  Widget fromToElement(index, value) {
    if (value.toString() == "loading") {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(widget.addressesList[index - 1].values.first)),
        Expanded(child: Text(value)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      WidgetWithRole(
          role: UserRole.customer,
          widgetName: "Map",
          child: MapConnector(
            role: widget.role,
          )),
      const SizedBox(
        height: 10.0,
      ),
      Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: Column(children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("From:"),
                Text("To"),
                Text("Drive Duration:"),
              ],
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                  itemCount: widget.addressesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: index > 0
                          ? fromToElement(
                              index, widget.addressesList[index].values.first)
                          : const SizedBox.shrink(),
                    );
                  }),
            )
          ]))
    ]);
  }
}
