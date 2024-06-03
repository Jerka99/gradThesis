
import 'package:flutter/material.dart';
import 'package:redux_example/myMap/address_class.dart';
import 'package:redux_example/role_handler.dart';
import 'package:redux_example/user_role.dart';

import '../../myMap/map_connector.dart';

class HomePage extends StatefulWidget {
  List<AddressClass> addressesList;
  UserRole? role;
  final Function(AddressClass) addAddress;
  static DateTime dataTime = DateTime.now();

  HomePage({
    super.key,
    required this.addressesList,
    this.role,
    required this.addAddress
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

  Widget fromToElement(index, AddressClass value) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
      decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black),
          )
      ),
      child: value.fullAddress.toString() == "loading" ?
      const Center(child: CircularProgressIndicator(
        color: Colors.black,
      )) : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.addressesList[index - 1].fullAddress ?? "-"),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(value.fullAddress ?? "-"),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(sumDrivingDurations(index).toString()),
              ),
            ),
          ),
        ],
      ),
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
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Center(child: Text(
                          "From:",
                      style: TextStyle(fontWeight: FontWeight.bold)
                        ,)))),
                  Expanded(child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Center(child: Text(
                          "To",
                      style: TextStyle(fontWeight: FontWeight.bold)
                        ,)))),
                  Expanded(child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Center(child: Text(
                          "Drive Duration:",
                      style: TextStyle(fontWeight: FontWeight.bold)
                        ,)))),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                  itemCount: widget.addressesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12, left: 12),
                      child: index > 0
                          ? fromToElement(
                              index, widget.addressesList[index])
                          : const SizedBox.shrink(),
                    );
                  }),
            )
          ]))
    ]);
  }

  DateTime sumDrivingDurations(int index) {
    double sum = 0;
    for (int i = 0; i <= index; i++) {
      sum += widget.addressesList[i].dataBetweenTwoAddresses!.duration;
    }
    return HomePage.dataTime.add(Duration(seconds: sum.toInt()));
  }
}
