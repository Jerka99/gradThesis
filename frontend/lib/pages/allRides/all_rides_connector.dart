import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/app_state.dart';
import 'package:travel_mate/myMap/all_rides_list.dart';
import 'package:travel_mate/myMap/map_actions.dart';
import 'package:travel_mate/pages/allRides/all_rides_page.dart';



class Factory extends VmFactory<AppState, AllRidesConnector, ViewModel> {
  @override
  ViewModel fromStore() =>
      ViewModel(
          fetchAllRides: () {
            dispatch(FetchMapData());
            },
          allRidesList: state.allRidesList,
        selectedId: state.selectedId
      );
}

class ViewModel extends Vm {
  final Function() fetchAllRides;
  final AllRidesList allRidesList;
  final int? selectedId;

  ViewModel({required this.fetchAllRides, required this.allRidesList, required this.selectedId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          fetchAllRides == other.fetchAllRides &&
          allRidesList == other.allRidesList &&
          selectedId == other.selectedId;

  @override
  int get hashCode =>
      super.hashCode ^ fetchAllRides.hashCode ^ allRidesList.hashCode ^ selectedId.hashCode;

  @override
  String toString() {
    return 'ViewModel{fetchAllRides: $fetchAllRides, allRidesList: $allRidesList, selectedId: $selectedId}';
  }
}

class AllRidesConnector extends StatelessWidget {
  const AllRidesConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
//this will prevent going back to login screen
        return AllRidesPage(
            fetchAllRides: vm.fetchAllRides,
            allRidesList: vm.allRidesList,
            selectedId: vm.selectedId
        );
      },
    );
  }
}
