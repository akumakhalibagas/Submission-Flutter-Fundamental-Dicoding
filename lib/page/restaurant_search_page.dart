import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/page/restaurant_list.dart';
import 'package:restaurant_flutter/provider/restaurant_provider.dart';

import '../utils/dimens.dart';

class RestaurantSearchPage extends StatelessWidget {
  static const routeName = '/restaurant_search_page';
  final String query;
  const RestaurantSearchPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestaurantProvider>(
        create: (_) => RestaurantProvider().searchRestaurant(query),
        child: Consumer<RestaurantProvider>(
          builder: (context, value, child) {
            if (value.state == ResultState.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    AppBar(
                      title: Text(query),
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      child: Container(
                        padding: const EdgeInsets.all(spacingSmall),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final data = value.resultS.restaurants[index];
                            return RestaurantList(data: data);
                          },
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: value.resultS.restaurants.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (value.state == ResultState.loading) {
              return Column(
                children: [
                  AppBar(
                    title: Text(query),
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            } else if (value.state == ResultState.error) {
              return Center(
                child: Text(value.msg),
              );
            }
            return Column(
              children: [
                AppBar(
                  title: Text(query),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
