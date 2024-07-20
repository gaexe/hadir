// To parse this JSON data, do
//
//     final responseDefault = responseDefaultFromJson(jsonString);

import 'dart:convert';

ResponseDefault responseDefaultFromJson(String str) => ResponseDefault.fromJson(json.decode(str));

String responseDefaultToJson(ResponseDefault data) => json.encode(data.toJson());

class ResponseDefault {
  String? name;
  String? error;

  ResponseDefault({
    this.name,
    this.error,
  });

  factory ResponseDefault.fromJson(Map<String, dynamic> json) => ResponseDefault(
        name: json["name"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "error": error,
      };
}
