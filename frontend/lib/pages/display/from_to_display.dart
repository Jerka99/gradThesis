import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AutoScrollingText.dart';
import '../../main.dart';
import '../../myMap/address_class.dart';

class FromToDisplay extends StatefulWidget {
  List<AddressClass> addressesList;
  final DateTime? dateTime;
  bool displayMore;
  bool displayCalendar;

  FromToDisplay(
      {required this.addressesList,
      required this.dateTime,
      this.displayMore = true,
      this.displayCalendar = true,
      super.key});

  @override
  State<FromToDisplay> createState() => _FromToDisplayState();
}

class _FromToDisplayState extends State<FromToDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.cyanAccent[50],
            border: Border.all(width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: Column(children: [
          ...listViewHeader(),
          widget.displayMore
              ? Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                        shrinkWrap: true,
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
                  ),
                )
              : const SizedBox.shrink()
        ]));
  }

  Widget fromToElement(index, AddressClass value) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.black),
      )),
      child: value.fullAddress.toString() == "loading"
          ? loading()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child:
                          // AutoScrollingText(
                          //     text: " ${widget.addressesList[index - 1].fullAddress ?? "-"}",
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.bold,
                          //     offset: Offset(100, 100))
                          Text(
                        "${widget.addressesList[index - 1].fullAddress} ${widget.addressesList[index - 1].city}" ??
                            "-",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "${value.fullAddress} ${value.city}" ?? "-",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "${sumDrivingDurations(index)?.hour}:${sumDrivingDurations(index)?.minute.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ))),
                        Expanded(
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "${sumDrivingDurations(index)?.day}.${sumDrivingDurations(index)?.month}.${sumDrivingDurations(index)?.year}",
                                style: const TextStyle(fontSize: 13),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Container> listViewHeader() {
    List<String> titles = ["From", "To", "Arrival"];
    return [
      Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: widget.addressesList.isNotEmpty &&
                                  widget.addressesList.first.fullAddress ==
                                      "loading"
                              ? loading()
                              : AutoScrollingText(
                                  text:
                                      " ${widget.addressesList.isNotEmpty ? "${widget.addressesList.first.fullAddress} ${widget.addressesList.first.city}" : ""}",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  offset: Offset(100, 0)))),
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25),
                    child: Text(
                      "-",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: widget.addressesList.length > 1 &&
                                  widget.addressesList.last.fullAddress ==
                                      "loading"
                              ? loading()
                              : AutoScrollingText(
                                  text:
                                      " ${widget.addressesList.length > 1 ? "${widget.addressesList.last.fullAddress} ${widget.addressesList.last.city}" : ""} ",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  offset: Offset(100, 0)))),
                ],
              ),
            ),
            Expanded(
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Starts at: ${widget.dateTime?.day}.${widget.dateTime?.month}.${widget.dateTime?.year} ${widget.dateTime?.hour}:${widget.dateTime?.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                 if(widget.displayCalendar) Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () async {
                            await appViewportKey.currentState
                                ?.showCalendarDialog();
                          },
                          icon: const Icon(
                            Icons.edit_calendar,
                            size: 30,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    if(widget.displayMore) Container(
        decoration: const BoxDecoration(
            color: Color(0x1A2196F3),
            border: Border(
              top: BorderSide(width: 1),
              bottom: BorderSide(color: Colors.black, width: 2),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...titles
                .map(
                  (title) => Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                              child: Text(
                            title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )))),
                )
                .toList()
          ],
        ),
      )
    ];
  }

  DateTime? sumDrivingDurations(int index) {
    double sum = 0;
    for (int i = 1; i <= index; i++) {
      sum += widget.addressesList[i].dataBetweenTwoAddresses!.duration;
    }
    DateTime? newDateTime =
        widget.dateTime?.add(Duration(seconds: sum.toInt()));
    return newDateTime;
  }

  Widget loading() {
    return const Center(
        child: CircularProgressIndicator(
      color: Colors.black,
    ));
  }
}
