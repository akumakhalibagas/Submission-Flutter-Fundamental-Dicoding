import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurant_review_result.dart';
import 'package:restaurant_flutter/provider/result_state.dart';

class RestaurantReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantReviewProvider({required this.apiService});

  late RestaurantReviewResult _reviewResult;
  ResultState _state = ResultState.noData;
  String _message = '';

  String get message => _message;

  RestaurantReviewResult get result => _reviewResult;

  ResultState get state => _state;

  Future<dynamic> postReview(String id, String name, String review) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.reviewRestaurant(id, name, review);
      _state = ResultState.hasData;
      notifyListeners();
      return _reviewResult = response;
    } on SocketException catch (_) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Check your internet connectivity';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  bool isReviewFormValid(String name, String review) {
    if (name.isEmpty) {
      _state = ResultState.error;
      _message = 'Nama tidak boleh kosong';
      notifyListeners();
      return false;
    }
    if (review.isEmpty) {
      _state = ResultState.error;
      _message = 'Review tidak boleh kosong';
      notifyListeners();
      return false;
    }
    return true;
  }
}
