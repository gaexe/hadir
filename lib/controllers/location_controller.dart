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
  final isLoadingLocation = true.obs;
  final isLoadingAttendance = true.obs;

  fetchLocations() async {
    isLoadingLocation.value = true;
    locations.value = await _remote.getLocations();
    isLoadingLocation.value = false;
  }

  fetchAttendance() async {
    isLoadingAttendance.value = true;
    attendance.value = await _remote.getAttendance();
    isLoadingAttendance.value = false;
  }
}
