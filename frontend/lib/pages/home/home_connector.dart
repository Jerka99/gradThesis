import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_mate/myMap/address_class.dart';

import '../../app_state.dart';
import '../../myMap/map_actions.dart';
import '../../user_role.dart';
import 'Home.dart';

class Factory extends VmFactory<AppState, HomeConnector, ViewModel> {
  @override
   ViewModel fromStore() =>
     ViewModel(
      addressesList: state.mapData!.addressesList,
       addAddress: (AddressClass address) {
         dispatch(MapActionAddressesManager(address));
       },
      role: state.user.role,
    );
}

class ViewModel extends Vm{

  final List<AddressClass> addressesList;
  Function(AddressClass) addAddress;
  UserRole? role;

  ViewModel({
    required this.addressesList,
    required this.addAddress,
    this.role,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          addAddress == other.addAddress &&
          addressesList == other.addressesList &&
          role == other.role;

  @override
  int get hashCode => super.hashCode ^ addressesList.hashCode ^ addAddress.hashCode ^ role.hashCode;
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
            addAddress: vm.addAddress,
            role: vm.role
        );},
    );
  }
}

