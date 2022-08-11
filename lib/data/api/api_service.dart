import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_flutter/data/models/restaurant_details_result.dart';
import 'package:restaurant_flutter/data/models/restaurant_review_result.dart';
import 'package:restaurant_flutter/data/models/restaurant_search_result.dart';
import 'package:restaurant_flutter/data/models/restaurants_result.dart';

class ApiService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev/";
  static const String baseImageUrlSmall =
      "https://restaurant-api.dicoding.dev/images/small/";
  static const String baseImageUrlMedium =
      "https://restaurant-api.dicoding.dev/images/medium/";
  static const String baseImageUrlLarge =
      "https://restaurant-api.dicoding.dev/images/large/";

  Future<RestaurantsResult> listRestaurants() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      debugPrint(response.body.toString());
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      debugPrint('ApiService -> Failed to load list restaurants');
      throw Exception('Failed to load list restaurants');
    }
  }

  Future<RestaurantSearchResult> searchRestaurants(String query) async {
    final uri =
        Uri.parse("${_baseUrl}search").replace(queryParameters: {'q': query});
    final response = await http.get(uri);
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      debugPrint(response.body.toString());
      return RestaurantSearchResult.fromJson(json.decode(response.body));
    } else {
      debugPrint('ApiService -> Failed to search restaurants');
      throw Exception('Failed to search restaurants');
    }
  }

  Future<RestaurantDetailsResult> detailsRestaurant(
      String idRestaurants) async {
    final uri = Uri.parse("${_baseUrl}detail/$idRestaurants");
    final response = await http.get(uri);
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      debugPrint(response.body.toString());
      return RestaurantDetailsResult.fromJson(json.decode(response.body));
    } else {
      debugPrint('ApiService -> Failed to detailsRestaurant');
      throw Exception('Failed to detailsRestaurant');
    }
  }

  Future<RestaurantReviewResult> reviewRestaurant(
      String id, String name, String review) async {
    final uri = Uri.parse("${_baseUrl}review");
    final Map<String, String> body = {
      "id": id,
      "name": name,
      "review": review,
    };
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 201) {
      debugPrint(response.body.toString());
      return RestaurantReviewResult.fromJson(json.decode(response.body));
    } else {
      debugPrint('ApiService -> Failed to reviewRestaurant');
      throw Exception('Failed to reviewRestaurant');
    }
  }
}
