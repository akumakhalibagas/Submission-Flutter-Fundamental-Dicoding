import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
import 'package:rxdart/rxdart.dart';

import '../common/navigation.dart';
import '../data/models/restaurants_result.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        if (payload != null) {
          print('notification payload: $payload');
          var data = Restaurant.fromJson(json.decode(payload));
          await Navigation.intentWithData(RestaurantDetailPage.routeName, data);
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantsResult response) async {
    var restaurant =
        response.restaurants[Random().nextInt(response.restaurants.length)];
    var channelId = '1';
    var channelName = 'channel_apps';
    var channelDesc = 'Restaurant Info';

    var androidPlatformChannelSpesifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlayfromChannelSpesifics = const IOSNotificationDetails();
    var platformChannelSpesifications = NotificationDetails(
        android: androidPlatformChannelSpesifics,
        iOS: iOSPlayfromChannelSpesifics);

    var title = "Restaurant Info";
    var subtitle = "Hallo sahabat ada promo nih di ${restaurant.name}";
    await flutterLocalNotificationsPlugin.show(
        0, title, subtitle, platformChannelSpesifications,
        payload: json.encode(restaurant.toJson()));
  }

  void configureNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((event) async {
      var data = Restaurant.fromJson(json.decode(event));
      Navigation.intentWithData(route, data);
    });
  }
}
