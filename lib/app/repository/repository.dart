import 'package:hadir/app/repository/remote/endpoints.dart';
import 'package:hadir/models/model_location.dart';

import '../../models/response_default.dart';
import 'remote/api_config.dart';

class Repository {
  final ApiConfig apiConfig;

  Repository({required this.apiConfig});

  Future<ResponseDefault> postLogin(ModelLocation payload) async {
    return await apiConfig.postCase(Endpoints.location, payload.toJson());
  }
}
