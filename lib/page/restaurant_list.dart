import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/provider/restaurant_provider.dart';
import 'package:restaurant_flutter/provider/result_state.dart';
import 'package:restaurant_flutter/widgets/card_restaurants.dart';

class RestaurantListPage extends StatelessWidget {
  final RestaurantProvider provider;

  const RestaurantListPage({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                var restaurant = state.result[index];
                return CardRestaurant(data: restaurant, provider: provider);
              },
            );
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Text(state.message),
            );
          } else if (state.state == ResultState.error) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text(''),
            );
          }
        },
      );
}
