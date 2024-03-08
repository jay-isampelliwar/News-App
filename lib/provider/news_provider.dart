import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news_app/model/news_data_model.dart';
import 'package:news_app/res/constants.dart';

import '../services/api_service.dart';

class NewsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _loading = false;
  String _selectedCategory = "Headlines";
  NewsDataModel? _newsDataModel;

  bool get loading => _loading;
  String get selectedCategory => _selectedCategory;
  NewsDataModel? get newsDataModel => _newsDataModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void selectCategory(String value) {
    _selectedCategory = value;
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      setLoading(true);
      var (model, status, message) =
          await ApiService().fetchNews(_selectedCategory);
      setLoading(false);
      if (status) {
        _newsDataModel = model;
      } else {
        log(message);
      }
    } catch (e) {
      setLoading(false);
      log(e.toString());
    }
  }

  Future<void> fetchHeadlinesNews() async {
    _selectedCategory = "Headlines";
    try {
      setLoading(true);
      var (model, status, message) =
          await ApiService().fetchHeadlineNews(COUNTRY);
      setLoading(false);
      if (status) {
        _newsDataModel = model;
      } else {
        log(message);
      }
    } catch (e) {
      setLoading(false);
      log(e.toString());
    }
  }
}
