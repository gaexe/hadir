class Location {
  final String id;
  final String address;
  final String latitude;
  final String longitude;
  final String name;
  final int radius;
  final String? time;

  Location({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.radius,
    this.time,
  });

  factory Location.fromJson(String id, Map<String, dynamic> json) {
    return Location(
      id: id,
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      name: json['name'],
      radius: json['radius'],
      time: json['time'],
    );
  }
}
