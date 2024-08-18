import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/myMap/map_actions.dart';
import 'package:travel_mate/navigation/navigation_action.dart';

import '../../app_state.dart';
import '../../model.dart';
import '../../myMap/personal_rides_list.dart';
import '../auth/auth_action.dart';
import 'my_profile.dart';

class MyProfileContainer extends StatelessWidget{

  const MyProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {

        return MyProfile(
            logOut: vm.logOut,
            fetchPersonalRides: vm.fetchPersonalRides,
            user: vm.user,
            personalRidesList: vm.personalRidesList,
            navigateToAllRides: vm.navigateToAllRides,
        );},
    );
  }
}

class _ViewModel extends Vm{

  final Function() logOut;
  final Function() fetchPersonalRides;
  final UserData user;
  final PersonalRidesList personalRidesList;
  final Function(int) navigateToAllRides;

  _ViewModel({
    required this.logOut,
    required this.fetchPersonalRides,
    required this.user,
    required this.personalRidesList,
    required this.navigateToAllRides,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        logOut: () {
          store.dispatch(LogOutAction());
        },
        fetchPersonalRides: () {
          store.dispatch(FetchPersonalMapData());
    },
      user: store.state.user,
      personalRidesList: store.state.personalRidesList,
      navigateToAllRides: (int rideId){
          store.dispatch(MyNavigateAction(route: "allRides", rideId: rideId));
    }
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is _ViewModel &&
          runtimeType == other.runtimeType &&
          logOut == other.logOut &&
          fetchPersonalRides == other.fetchPersonalRides &&
          user == other.user &&
          personalRidesList == other.personalRidesList;

  @override
  int get hashCode =>
      super.hashCode ^
      logOut.hashCode ^
      fetchPersonalRides.hashCode ^
      user.hashCode ^
      personalRidesList.hashCode;

  @override
  String toString() {
    return '_ViewModel{logOut: $logOut, fetchPersonalRides: $fetchPersonalRides, user: $user, personalRidesList: $personalRidesList}';
  }
}
