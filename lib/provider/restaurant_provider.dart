import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/database/db_service.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/provider/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final DatabaseService databaseService;

  RestaurantProvider({required this.databaseService, required this.apiService});

  late List<Restaurant> _restaurantsResult;
  List<Restaurant> get result => _restaurantsResult;

  late List<Restaurant> _favoritesResult;
  List<Restaurant> get favorites => _favoritesResult;

  late ResultState _state;
  String _message = '';

  String get message => _message;

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

  Future<dynamic> fetchRestaurantFavorites() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await databaseService.getFavorites();
      if (response.isNotEmpty) {
        _state = ResultState.hasData;
        notifyListeners();
        return _favoritesResult = response;
      } else {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> setFavorites(Restaurant data) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await databaseService.setFavorites(data);
      if (response.isNotEmpty) {
        _state = ResultState.hasData;
        notifyListeners();
        return _favoritesResult = response;
      } else {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
