import 'package:geocoding/geocoding.dart';

class MyCommon {
  static Future<String> getAddress(double latitude, double longitude) async {
    final place = await placemarkFromCoordinates(latitude, longitude);
    return "${place.first.street}, ${place.first.name}, ${place.first.subLocality}, ${place.first.locality}, ${place.first.postalCode}";
  }
}
