
class DataBetweenTwoAddresses{
  double duration;
  double distance;

  DataBetweenTwoAddresses(this.duration, this.distance);

  Map<String, dynamic> toJson() => {
    'duration': duration,
    'distance': distance,
  };

  DataBetweenTwoAddresses.fromJson(Map<String, dynamic> json)
      : duration = json['duration'] as double,
        distance = json['distance'] as double;
}

class AddressClass{
  String? fullAddress;
  String? city;
  DataBetweenTwoAddresses? dataBetweenTwoAddresses;
  int? stationCapacity;

  AddressClass({
    this.fullAddress,
    this.city,
    this.dataBetweenTwoAddresses,
    this.stationCapacity,
  });

  Map<String, dynamic> toJson() => {
    'fullAddress': fullAddress,
    'city': city,
    'dataBetweenTwoAddresses': dataBetweenTwoAddresses,
  };

  AddressClass.fromJson(Map<String, dynamic> json)
      : fullAddress = json['fullAddress'] as String?,
        city = json['city'] as String?,
        dataBetweenTwoAddresses = DataBetweenTwoAddresses.fromJson(json['dataBetweenTwoAddresses']),
        stationCapacity = json['stationCapacity'] as int;
}