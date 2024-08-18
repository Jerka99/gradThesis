
class PersonalRide {
  int? rideId;
  String? firstLocation;
  String? lastLocation;
  DateTime? date;

  PersonalRide({this.rideId, this.firstLocation, this.lastLocation, this.date});

  PersonalRide.fromJson(Map<String, dynamic> json)
      : rideId = json['rideId'] as int,
        firstLocation = json['firstLocation'] as String,
        lastLocation = json['lastLocation'] as String;
        // date = json['date'] as DateTime;
}

class PersonalRidesList {
  List<PersonalRide> listOfRides;

  PersonalRidesList({
    required this.listOfRides,
  });

  PersonalRidesList.init()
      : listOfRides = [];

  PersonalRidesList copyWith({
    required List<PersonalRide>? listOfRides,
  }) {
    return PersonalRidesList(
      listOfRides: listOfRides ?? this.listOfRides,
    );
  }
}