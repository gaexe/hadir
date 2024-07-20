import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => Full Path: ${options.uri}');
    debugPrint('REQUEST[${options.method}] => Header: ${options.headers.entries}');
    try {
      debugPrint('REQUEST[PAYLOAD] => payload: ${jsonEncode(options.data)}');
    } catch (e) {
      debugPrint('REQUEST[PAYLOAD] => body: object is not json but multipart!');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.statusCode}] => Path: ${response.requestOptions.path}');
    debugPrint('RESPONSE[${response.statusCode}] => Body: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint('ERROR[${err.response?.statusCode}] => Full Path: ${err.requestOptions.uri}');
    debugPrint('ERROR[${err.response?.statusCode}] => Header: ${err.requestOptions.headers.entries}');
    debugPrint('ERROR[${err.response?.statusCode}] => Body: ${err.response}');
    return super.onError(err, handler);
  }
}
