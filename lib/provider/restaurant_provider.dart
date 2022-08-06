import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'dart:async';

enum ResultState { loading, empty, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  late RestaurantResponse _resultRestaurant;
  late RestaurantResponseSearch _resultRestaurantS;
  late ResultState _state;
  String _msg = '';
  String _query = '';

  String get msg => _msg;
  ResultState get state => _state;
  RestaurantResponse get result => _resultRestaurant;
  RestaurantResponseSearch get resultS => _resultRestaurantS;

  RestaurantProvider getRestaurant() {
    _getRestaurant();
    return this;
  }

  RestaurantProvider searchRestaurant(String query) {
    _query = query;
    _searchRestaurant();
    return this;
  }

  Future<dynamic> _getRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurant = await apiService.getRestaurant();

      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.empty;
        notifyListeners();
        return _msg = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _resultRestaurant = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _msg = 'Error --> $e';
    }
  }

  Future<dynamic> _searchRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurant = await apiService.searchRestaurant(_query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.empty;
        notifyListeners();
        return _msg = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _resultRestaurantS = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _msg = 'Error --> $e';
    }
  }
}
