import 'dart:isolate';
import 'dart:ui';

import 'package:restaurant_flutter/data/api/api_service.dart';
import 'package:restaurant_flutter/utils/notification_helper.dart';
import 'package:restaurant_flutter/main.dart';

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
    print('Alarm Fired!');
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService().listRestaurants();
    await notificationHelper.showNotifications(
        flutterLocalNotificationsPlugin, result);
    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
