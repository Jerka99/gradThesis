import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Date {
  double? year;
  double? month;
  double? day;
  double? hour;
  double? minute;

  Date({this.year, this.month, this.day, this.hour, this.minute});

  Date copyWith({
    double? year,
    double? month,
    double? day,
    double? hour,
    double? minute,
  }) {
    return Date(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Change your desired color here
            hintColor: Colors.blue, // Change your desired color here
            colorScheme: const ColorScheme.light(primary: Colors.blue), // Change your desired color here
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // var parentPadding = MediaQuery.of(parent.context).padding;
    return Dialog(
      insetPadding:
          const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: Container(
        constraints: BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fit the content
          children: [
            Container(
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 1, color: Colors.black)),
              ),
              height: 400,
              child: TableCalendar(
                calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                ),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay =
                        focusedDay; // update `_focusedDay` here as well
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 1, color: Colors.black)),
              ),
              padding: EdgeInsets.only(top: 2, bottom: 2),
              child: Row(
                children: [
                  Expanded(
                      child: Align(
                    child: Text(
                      "${_selectedTime.hour} : ${_selectedTime.minute}",
                      style: const TextStyle(fontSize: 25),
                    ),
                  )),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectTime(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white, // Button color
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rectangle shape
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0), // Adjust the padding as needed
                      ),
                      child: const Text(
                        "Choose Time",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  DateTime selectedDateTime = DateTime(
                    _selectedDay.year,
                    _selectedDay.month,
                    _selectedDay.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );
                  Navigator.of(context).pop(selectedDateTime);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Button color
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Rectangle shape
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0), // Adjust the padding as needed
                ),
                child: const Text('SAVE', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
