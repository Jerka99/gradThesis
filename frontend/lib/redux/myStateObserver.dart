 import 'package:async_redux/async_redux.dart';
import 'package:travel_mate/app_state.dart';

class MyStateObserver implements StateObserver<AppState>{

  @override
  void observe(ReduxAction<AppState> action, AppState prevState, AppState newState, Object? error, int dispatchCount) {
  var x = action;
  }

}