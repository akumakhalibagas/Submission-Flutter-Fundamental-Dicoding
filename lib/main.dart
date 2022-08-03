import 'package:flutter/material.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
import 'package:restaurant_flutter/page/restaurant_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RestaurantHome.routeName,
      routes: routes,
    );
  }
}

final Map<String, WidgetBuilder> routes = {
  RestaurantHome.routeName: (context) => const RestaurantHome(),
  RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
      data: ModalRoute.of(context)?.settings.arguments as Restaurant),
};
