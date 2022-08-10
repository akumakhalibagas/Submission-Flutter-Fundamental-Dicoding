import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_flutter/data/models/restaurant.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/navigation.dart';

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
          debugPrint('notification payload: $payload');
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    Restaurant response,
  ) async {
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

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifications = NotificationDetails(
      android: androidPlatformChannelSpesifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var title = "Restaurant Info";
    var subtitle = "Hallo bordii ada promo nih di ${response.name}. Yuk, check sekarang!";
    await flutterLocalNotificationsPlugin.show(
      0, // id
      title, // title
      subtitle, // body
      platformChannelSpecifications,
      payload: json.encode(
        response.toJson(),
      ),
    );
  }

  void configureNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((event) async {
      var data = Restaurant.fromJson(json.decode(event));
      Navigation.intentWithData(route, data.id);
    });
  }
}
