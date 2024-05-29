import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

import '../../app_state.dart';
import '../../user_role.dart';
import 'Home.dart';

class Factory extends VmFactory<AppState, HomeConnector, ViewModel> {
  @override
   ViewModel fromStore() =>
     ViewModel(
      addressesList: state.mapData!.addressesList,
      role: state.user.role,
    );
}

class ViewModel extends Vm{

  final List<Map<Coordinate, String>> addressesList;
  UserRole? role;

  ViewModel({
    required this.addressesList,
    this.role,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          addressesList == other.addressesList &&
          role == other.role;

  @override
  int get hashCode => super.hashCode ^ addressesList.hashCode ^ role.hashCode;
}



class HomeConnector extends StatelessWidget{

  const HomeConnector({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {

        return HomePage(
            addressesList: vm.addressesList,
            role: vm.role
        );},
    );
  }
}

