import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:news_app/model/news_data_model.dart';
import 'package:news_app/res/constants.dart';
import 'package:news_app/services/app_interceptore.dart';

class ApiService {
  late Dio dio;
//2014f2c2066e4fec992863f88e409c00
  ApiService() {
    dio = Dio();
    dio
      ..options.baseUrl = BASE_URL
      ..httpClientAdapter
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.receiveTimeout = const Duration(seconds: 10)
      ..options.headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
      };

    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(LogInterceptor());
  }

  Future<(NewsDataModel?, bool, String)> fetchNews(String topic) async {
    try {
      final queryParameters = {
        'q': topic,
        'from': '2024-03-06',
        'to': '2024-03-06',
        'sortBy': 'popularity',
      };
      var res = await dio.get("everything", queryParameters: queryParameters);

      return (NewsDataModel.fromJson(res.data), true, "");
    } on DioException catch (e) {
      String message = e.response!.statusMessage.toString();
      return (null, false, message);
    }
  }

  Future<(NewsDataModel?, bool, String)> fetchHeadlineNews(
      String country) async {
    try {
      final queryParameters = {
        'country': country,
      };
      var res =
          await dio.get("top-headlines", queryParameters: queryParameters);

      return (
        // NewsDataModel.fromJson(json.decode(res.data.toString())),
        NewsDataModel.fromJson(res.data),
        true,
        ""
      );
    } on DioException catch (e) {
      String message = e.response!.statusMessage.toString();
      return (null, false, message);
    }
  }
}
