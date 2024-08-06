import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/app_state.dart';
import 'package:travel_mate/main_api.dart';
import 'package:travel_mate/myMap/map_actions.dart';
import 'package:travel_mate/navigation/navigation_action.dart';
import 'package:travel_mate/pages/allRides/all_rides_page.dart';


class Factory extends VmFactory<AppState, AllRidesConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(fetchAllRides: () {
        dispatch(FetchMapData());
      });
}

class ViewModel extends Vm {
  final Function() fetchAllRides;

  ViewModel({required this.fetchAllRides});
}

class AllRidesConnector extends StatelessWidget {
  const AllRidesConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
//this will prevent going back to login screen
        return AllRidesPage(fetchAllRides: vm.fetchAllRides);
      },
    );
  }
}
