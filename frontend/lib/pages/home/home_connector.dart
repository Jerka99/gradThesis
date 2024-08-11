import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_mate/myMap/address_class.dart';
import 'package:travel_mate/myMap/fetch_location_action.dart';

import '../../app_state.dart';
import '../../myMap/map_actions.dart';
import '../../user_role.dart';
import 'Home.dart';

class Factory extends VmFactory<AppState, HomeConnector, ViewModel> {
  @override
   ViewModel fromStore() =>
     ViewModel(
         fetchLocation: () {
           dispatch(FetchLocationAction());
         },
     );
}

class ViewModel extends Vm{
  Function() fetchLocation;

  ViewModel({
    required this.fetchLocation,
  });
}



class HomeConnector extends StatelessWidget{

  const HomeConnector({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {

        return HomePage(
            fetchLocation: vm.fetchLocation,
        );},
    );
  }
}

