import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<RestaurantResponse> getRestaurant() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return restaurantResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  Future<RestaurantResponseSearch> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse('${_baseUrl}search?q=$query'));
    if (response.statusCode == 200) {
      return restaurantResponseSearchFromJson(response.body);
    } else {
      throw Exception('Failed to load restaurant');
    }
  }
}
