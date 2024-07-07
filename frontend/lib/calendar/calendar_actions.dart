import 'package:async_redux/async_redux.dart';

import '../app_state.dart';

class SetDateTimeForCalendar extends ReduxAction<AppState>{
  DateTime dateTime;


  SetDateTimeForCalendar(this.dateTime);

  @override
  AppState reduce() {
    return state.copy(dateTime: dateTime.copyWith(
        year: dateTime.year,
        month: dateTime.month,
        hour: dateTime.hour,
        minute: dateTime.minute
    ));
  }
}