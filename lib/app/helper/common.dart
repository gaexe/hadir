import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class MyCommon {
  static Future<String> getAddress(double latitude, double longitude) async {
    final place = await placemarkFromCoordinates(latitude, longitude);
    return "${place.first.street}, ${place.first.name}, ${place.first.subLocality}, ${place.first.locality}, ${place.first.postalCode}";
  }

  static String dateNowDisplay() => DateFormat('E, dd MMM yyyy HH:mm').format(DateTime.now());

}
