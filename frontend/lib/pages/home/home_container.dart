import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:redux_example/navigation/navigation_action.dart';

import '../../app_state.dart';
import '../../user_role.dart';
import 'Home.dart';

class HomeContainer extends StatelessWidget{

  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {

        return HomePage(
            addressesList: vm.addressesList,
            role: vm.role
        );},
    );
  }
}

class _ViewModel extends Vm{

  final List<Map<Coordinate, String>> addressesList;
  UserRole? role;

  _ViewModel({
    required this.addressesList,
    this.role,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      addressesList: store.state.mapData!.addressesList,
      role: store.state.user.role,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is _ViewModel &&
          runtimeType == other.runtimeType &&
          addressesList == other.addressesList &&
          role == other.role;

  @override
  int get hashCode => super.hashCode ^ addressesList.hashCode ^ role.hashCode;
}
