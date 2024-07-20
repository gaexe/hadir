import 'package:get/get.dart';
import 'package:hadir/app/repository/repository.dart';

import '../app/repository/remote/api_config.dart';

class HomeController extends GetxController {
  /// protocol
  final _remote = Repository(apiConfig: ApiConfig());

  /// remote
  final successMessage = "".obs;
  final failedMessage = "".obs;
}
