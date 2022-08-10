import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/main.dart';
import 'package:restaurant_flutter/utils/service/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _backgroundService;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _backgroundService = this;
  }

  factory BackgroundService() =>
      _backgroundService ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    debugPrint('Alarm Fired!');
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService().listRestaurants();
    var randomRestaurant = result.restaurants[Random().nextInt(result.restaurants.length)];
    await notificationHelper.showNotifications(flutterLocalNotificationsPlugin, randomRestaurant);
    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
