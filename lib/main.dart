import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_flutter/common/styles.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/page/home_page.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.routeName,
      routes: routes,
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: colorPrimary,
            onPrimary: colorWhite,
            secondary: colorSecondary),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
        textTheme: myTextTheme,
      ),
    );
  }
}

final Map<String, WidgetBuilder> routes = {
  HomePage.routeName: (context) => const HomePage(),
  RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
      data: ModalRoute.of(context)?.settings.arguments as Restaurant),
};
