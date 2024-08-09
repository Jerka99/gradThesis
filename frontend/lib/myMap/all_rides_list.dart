import 'map_data_class.dart';

class AllRidesList {
  List<MapData> listOfRides;

  AllRidesList({
    required this.listOfRides
  });

  AllRidesList.init() : listOfRides = [];

  AllRidesList copyWith({required List<MapData>? listOfRides}) {
    return AllRidesList(listOfRides: listOfRides ?? this.listOfRides);
  }
}