import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurant_details_result.dart';
import 'package:restaurant_flutter/provider/result_state.dart';

class RestaurantDetailsProvider extends ChangeNotifier {
  final ApiService apiService;
  final String idRestaurant;

  RestaurantDetailsProvider(
      {required this.apiService, required this.idRestaurant}) {
    _fetchDetailRestaurants(idRestaurant);
  }

  late RestaurantDetails _restaurantsResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantDetails get result => _restaurantsResult;

  ResultState get state => _state;

  Future<dynamic> _fetchDetailRestaurants(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.detailsRestaurant(id);

      _state = ResultState.hasData;
      notifyListeners();
      return _restaurantsResult = response.restaurant;
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
}
