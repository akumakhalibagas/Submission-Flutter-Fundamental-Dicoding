import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant_flutter/utils/service/background_service.dart';
import 'package:restaurant_flutter/utils/service/date_time_helper.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledInfo(bool state) async {
    _isScheduled = state;
    if (_isScheduled) {
      debugPrint('Scheduling promo activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      debugPrint('Schedule promo canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
