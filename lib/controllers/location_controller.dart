import 'package:get/get.dart';
import 'package:hadir/app/repository/repository.dart';

import '../app/repository/remote/api_config.dart';
import '../models/response_location.dart';

class LocationController extends GetxController {
  /// protocol
  final _remote = Repository(apiConfig: ApiConfig());

  /// common
  final locations = <Location>[].obs;

  fetchLocations() async {
    final data = await _remote.getLocations();
    locations.value = data;
    locations.refresh();
    // final data = await _remote.getOri();
    // Map<String, dynamic> jsonMap = jsonDecode(data.toString());
    // locations.value = jsonMap.entries.map((entry) {
    //   return Location.fromJson(entry.key, entry.value);
    // }).toList();
    print("wtf ${locations.value}");
  }
}
