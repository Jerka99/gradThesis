import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/calendar/Calendar.dart';
import 'package:travel_mate/calendar/calendar_actions.dart';

import '../../app_state.dart';

class Factory extends VmFactory<AppState, CalendarConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
        setDateTime: (DateTime dateTime) {
          dispatch(SetDateTimeForCalendar(dateTime));
          },
        dateTime: state.dateTime,
      );
}

class ViewModel extends Vm{

  DateTime dateTime;
  Function(DateTime dateTime) setDateTime;

  ViewModel({
    required this.dateTime,
    required this.setDateTime
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          dateTime == other.dateTime &&
          setDateTime == other.setDateTime;

  @override
  int get hashCode => super.hashCode ^ dateTime.hashCode ^ setDateTime.hashCode;
}



class CalendarConnector extends StatelessWidget{

  const CalendarConnector({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {

        return Calendar(
          dateTime: vm.dateTime,
          setDateTime: vm.setDateTime,
        );},
    );
  }
}

