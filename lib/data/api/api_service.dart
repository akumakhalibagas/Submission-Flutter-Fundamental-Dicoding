import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_flutter/data/models/restaurants_result.dart';

class ApiService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev/";
  static const String baseImageUrlSmall = "https://restaurant-api.dicoding.dev/images/small/";
  static const String baseImageUrlMedium = "https://restaurant-api.dicoding.dev/images/medium/";
  static const String baseImageUrlLarge = "https://restaurant-api.dicoding.dev/images/large/";

  Future<RestaurantsResult> listRestaurants() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load list restaurants');
    }
  }
}
