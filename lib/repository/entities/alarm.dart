import 'package:get/get.dart';
import 'package:listree/config/local_notifications/local_notifications.dart';

abstract class Alarm {
  Rx<DateTime> _dateTime = newDateTime().obs;

  RxInt _repeatCount = 0.obs;

  DateTime get dateTime => _dateTime.value;

  String get dateTimeFormatted => [
        dateTime.day,
        dateTime.month,
        dateTime.year,
      ].join('/');

  int get repeatCount => _repeatCount.value;

  set dateTime(DateTime newDateTime) => _dateTime.value = newDateTime;

  set repeatCount(int value) {
    _repeatCount.value = value;
  }

  Future<void> cancelAlarm(int _id) async =>
      await Get.find<LocalNotifications>().cancelAlarmById(_id);

  static DateTime newDateTime() {
    final DateTime _currentDateTime = DateTime.now();
    final DateTime _zeroHourDateTime = _currentDateTime.subtract(
      Duration(
        hours: _currentDateTime.hour,
        minutes: _currentDateTime.minute,
        seconds: _currentDateTime.second,
      ),
    );

    return _zeroHourDateTime.add(Duration(hours: 8));
  }
}
