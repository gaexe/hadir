import 'package:hadir/app/repository/remote/endpoints.dart';
import 'package:hadir/models/model_location.dart';
import 'package:hadir/models/response_location.dart';

import '../../models/response_default.dart';
import 'remote/api_config.dart';

class Repository {
  final ApiConfig apiConfig;

  Repository({required this.apiConfig});

  Future<ResponseDefault> postNewLocation(ModelLocation payload) async {
    return await apiConfig.postCase(Endpoints.location, payload.toJson());
  }

  Future<List<Location>> getLocations() async {
    return await apiConfig.getCase(Endpoints.location, null);
  }

  Future<ResponseDefault> postNewAttendance(ModelLocation payload) async {
    return await apiConfig.postCase(Endpoints.attendance, payload.toJson());
  }

  Future<List<Location>> getAttendance() async {
    return await apiConfig.getCase(Endpoints.attendance, null);
  }
}
