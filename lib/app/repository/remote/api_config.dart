import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hadir/app/repository/remote/endpoints.dart';
import 'package:hadir/models/response_location.dart';

import '../../../models/response_default.dart';
import 'api_interceptor.dart';

class ApiConfig {
  final _defaultInterceptor = ApiInterceptor();

  Future<BaseOptions> _options() async {
    return BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
    );
  }

  Future<ResponseDefault> postCase(String endpoint, Map body) async {
    late ResponseDefault result;
    try {
      final dio = Dio(await _options());
      dio.interceptors.add(_defaultInterceptor);
      final response = await dio.post(endpoint, data: body);
      result = ResponseDefault.fromJson(response.data);
    } catch (e) {
      result = ResponseDefault(name: "$e");
    }
    return result;
  }

  Future<List<Location>> getCase(String endpoint, Map<String, dynamic>? params) async {
    late List<Location> result;
    try {
      final dio = Dio(await _options());
      dio.interceptors.add(_defaultInterceptor);
      final response = await dio.get(endpoint, queryParameters: params);
      Map<String, dynamic> jsonMap = jsonDecode(response.toString());
      result = jsonMap.entries.map((entry) {
        return Location.fromJson(entry.key, entry.value);
      }).toList();
    } catch (e) {
      result = List.empty();
    }
    return result;
  }
}
