import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/provider/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService});

  late List<Restaurant> _restaurantsResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  List<Restaurant> get result => _restaurantsResult;

  ResultState get state => _state;

  Future<dynamic> fetchListRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.listRestaurants();
      if (response.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = response.restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> fetchSearchRestaurants(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.searchRestaurants(query);
      if (response.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = response.restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
