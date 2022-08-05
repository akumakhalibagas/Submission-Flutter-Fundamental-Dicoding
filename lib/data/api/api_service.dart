import 'dart:convert';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = 'https://restaurant-api.dicoding.dev/list';

  Future<RestaurantResponse> getRestaurant() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return RestaurantResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant');
    }
  }
}
