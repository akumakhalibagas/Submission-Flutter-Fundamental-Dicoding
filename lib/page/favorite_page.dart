import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/page/restaurant_list_fav.dart';
import '../data/api/api_service.dart';
import '../data/database/db_service.dart';
import '../provider/restaurant_provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  var provider = RestaurantProvider(
      databaseService: DatabaseService(), apiService: ApiService());
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Scaffold(
          appBar: AppBar(
            title: const Text('Favorite'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ChangeNotifierProvider<RestaurantProvider>(
                  create: (_) {
                    provider.fetchRestaurantFavorites();
                    return provider;
                  },
                  child: const RestaurantListFavPage(),
                ),
              ],
            ),
          ),
        ),
      );
}
