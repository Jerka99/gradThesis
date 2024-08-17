import 'map_data_class.dart';
import 'package:async_redux/async_redux.dart';

class AllRidesList {
  List<MapData> listOfRides;
  Event<bool>? areMarkersFetched;

  AllRidesList({
    required this.listOfRides,
    this.areMarkersFetched
  });

  AllRidesList.init()
      : listOfRides = [],
        areMarkersFetched = Event<bool>.spent();

  AllRidesList copyWith({
    required List<MapData>? listOfRides,
    Event<bool>? areMarkersFetched,
    }) {
    return AllRidesList(
        listOfRides: listOfRides ?? this.listOfRides,
        areMarkersFetched: areMarkersFetched ?? this.areMarkersFetched,
    );
  }
}