import 'package:flutter/widgets.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:restaurant_flutter/utils/background_service.dart';
import 'package:restaurant_flutter/utils/date_time_helper.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledInfo(bool b) async {
    _isScheduled = b;
    debugPrint('b adalah $b');
    if (_isScheduled) {
      debugPrint('Scheduling info Activates');
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
      debugPrint('Schedule info Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
