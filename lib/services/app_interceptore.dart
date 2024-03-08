import 'dart:developer';

import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({
      'Authorization': "Bearer 2014f2c2066e4fec992863f88e409c00",
    });
    return handler.next(options);
  }
}
