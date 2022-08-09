import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';

class DatabaseService {
  late Box<dynamic> box;

  DatabaseService() {
    box = Hive.box('Favorites');
  }

  Future<List<Restaurant>> getFavorites() async {
    return box.values.toList().cast<Restaurant>();
  }

  Future<List<Restaurant>> setFavorites(Restaurant data) async {
    try {
      if (box.get(data.id) == null) {
        box.put(data.id, data);
      } else {
        box.delete(data.id);
      }
      return box.values.toList().cast<Restaurant>();
    } catch (e) {
      throw HiveError(e.toString());
    }
  }
}
