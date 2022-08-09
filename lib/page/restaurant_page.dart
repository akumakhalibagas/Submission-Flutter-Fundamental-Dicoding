import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/dimens.dart';
import 'package:restaurant_flutter/common/styles.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/data/database/db_service.dart';
import 'package:restaurant_flutter/page/restaurant_list.dart';
import 'package:restaurant_flutter/provider/restaurant_provider.dart';

class RestaurantPage extends StatefulWidget {
  static String routeName = "/restaurant";

  const RestaurantPage({Key? key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  var provider = RestaurantProvider(
      databaseService: DatabaseService(), apiService: ApiService());

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Scaffold(
          appBar: AppBar(
            title: const Text('Restaurant'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: spacingSmaller,
                    horizontal: spacingRegular,
                  ),
                  child: TextFormField(
                    onChanged: (query) {
                      query.isNotEmpty
                          ? provider.fetchSearchRestaurants(query)
                          : provider.fetchListRestaurants();
                    },
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context).textTheme.bodyText2?.apply(
                            color: colorGray,
                          ),
                      hintText: "Cari restaurant yang kamu mau...",
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(
                        Icons.search,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                ChangeNotifierProvider<RestaurantProvider>(
                  create: (_) {
                    provider.fetchListRestaurants();
                    return provider;
                  },
                  child: const RestaurantListPage(),
                ),
              ],
            ),
          ),
        ),
      );
}
