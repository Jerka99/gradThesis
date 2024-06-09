import 'package:flutter/material.dart';
import 'package:redux_example/myMap/address_class.dart';
import 'package:redux_example/role_handler.dart';
import 'package:redux_example/user_role.dart';

import '../../Calendar.dart';
import '../../myMap/map_connector.dart';

class HomePage extends StatefulWidget {
  List<AddressClass> addressesList;
  UserRole? role;
  final Function(AddressClass) addAddress;
  late DateTime? dateTime;

  HomePage({
    super.key,
    required this.addressesList,
    this.role,
    required this.addAddress,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
  }

  Widget fromToElement(index, AddressClass value) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.black),
      )),
      child: value.fullAddress.toString() == "loading"
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          widget.addressesList[index - 1].fullAddress ?? "-"),
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
                      child: Text(sumDrivingDurations(index)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Container> listViewHeader() {
    return [
      Container(
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                    child: Align(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "${widget.addressesList.isNotEmpty ? widget.addressesList.first.fullAddress : ""}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )))),
                const Text("-"),
                Expanded(
                    child: Align(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              " ${widget.addressesList.isNotEmpty ? widget.addressesList.last.fullAddress : ""}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )))),
              ],
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Starts at: ${formatDate(widget.dateTime)}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const Calendar();
                              },
                            ).then((selectedDateTime) {
                              if (selectedDateTime != null) {
                                setState(() {
                                  widget.dateTime = selectedDateTime;
                                });
                              }
                            })
                          },
                      icon: const Icon(
                        Icons.edit_calendar,
                        size: 30,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Center(
                        child: Text(
                      "From:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )))),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Center(
                        child: Text(
                      "To",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )))),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Center(
                        child: Text(
                      "Drive Duration:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )))),
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
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
          child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Colors.cyanAccent[50],
                  border: Border.all(width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              child: Column(children: [
                ...listViewHeader(),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.addressesList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12, left: 12),
                            child: index > 0
                                ? fromToElement(index, widget.addressesList[index])
                                : const SizedBox.shrink(),
                          );
                        }),
                  ),
                )
              ])),
        )
      ]),
    );
  }

  String sumDrivingDurations(int index) {
    double sum = 0;
    for (int i = 0; i <= index; i++) {
      sum += widget.addressesList[i].dataBetweenTwoAddresses!.duration;
    }
    DateTime? newDateTime =
        widget.dateTime?.add(Duration(seconds: sum.toInt()));
    return formatDate(newDateTime);
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime != null) {
      return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return "-";
    }
  }
}
