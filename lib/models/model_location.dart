// To parse this JSON data, do
//
//     final modelLocation = modelLocationFromJson(jsonString);

import 'dart:convert';

ModelLocation modelLocationFromJson(String str) => ModelLocation.fromJson(json.decode(str));

String modelLocationToJson(ModelLocation data) => json.encode(data.toJson());

class ModelLocation {
  String name;
  String latitude;
  String longitude;
  String radius;

  ModelLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory ModelLocation.fromJson(Map<String, dynamic> json) => ModelLocation(
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        radius: json["radius"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "radius": radius,
      };
}
