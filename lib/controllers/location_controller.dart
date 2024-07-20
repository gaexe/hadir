import 'package:get/get.dart';
import 'package:hadir/app/repository/repository.dart';

import '../app/repository/remote/api_config.dart';
import '../models/response_location.dart';

class LocationController extends GetxController {
  /// protocol
  final _remote = Repository(apiConfig: ApiConfig());

  /// common
  final locations = <Location>[].obs;
  final attendance = <Location>[].obs;

  fetchLocations() async {
    final data = await _remote.getLocations();
    locations.value = data;
    locations.refresh();
  }

  fetchAttendance() async {
    final data = await _remote.getAttendance();
    attendance.value = data;
    attendance.refresh();
  }
}
