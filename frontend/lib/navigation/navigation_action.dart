
import 'package:async_redux/async_redux.dart';
import 'package:travel_mate/app_state.dart';

class MyNavigateAction extends ReduxAction<AppState>{
  String route;
  int? rideId;

  MyNavigateAction({
    required this.route,
    this.rideId
  });

  @override
  AppState reduce() {
    store.state.routerDelegate.myNavigate(route);
    return state.copy(route: route, selectedId: rideId);
  }
}