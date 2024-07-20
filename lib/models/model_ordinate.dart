// To parse this JSON data, do
//
//     final modelOrdinate = modelOrdinateFromJson(jsonString);

import 'dart:convert';

ModelOrdinate modelOrdinateFromJson(String str) => ModelOrdinate.fromJson(json.decode(str));

String modelOrdinateToJson(ModelOrdinate data) => json.encode(data.toJson());

class ModelOrdinate {
  double? latitude;
  double? longitude;

  ModelOrdinate({
    this.latitude,
    this.longitude,
  });

  factory ModelOrdinate.fromJson(Map<String, dynamic> json) => ModelOrdinate(
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
