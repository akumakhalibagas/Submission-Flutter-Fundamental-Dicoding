import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/navigation.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/page/home_page.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
import 'package:restaurant_flutter/provider/preferences_provider.dart';
import 'package:restaurant_flutter/provider/schedule_provider.dart';
import 'package:restaurant_flutter/utils/service/background_service.dart';
import 'package:restaurant_flutter/utils/service/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/preferences/preferences_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService backgroundService = BackgroundService();

  backgroundService.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  await Hive.initFlutter();
  Hive.registerAdapter(RestaurantAdapter());
  await Hive.openBox('Favorites');
  await Hive.openBox('Themes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
            create: (_) => SettingsProvider()),
        ChangeNotifierProvider<PreferencesProvider>(
            create: (_) => PreferencesProvider(
                  preferencesHelper: PreferencesHelper(
                    sharedPreferences: SharedPreferences.getInstance(),
                  ),
                )),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: HomePage.routeName,
            routes: routes,
            navigatorKey: navigatorKey,
            theme: provider.themeData,
          );
        },
      ),
    );
  }
}

final Map<String, WidgetBuilder> routes = {
  HomePage.routeName: (context) => const HomePage(),
  RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
      restaurantId: ModalRoute.of(context)?.settings.arguments as String),
};
