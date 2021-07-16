import 'package:get/get.dart';
import 'package:listree/config/local_notifications/local_notifications.dart';

abstract class Alarm {
  Rx<DateTime> _dateTime = DateTime.now().obs;
  RxInt _repeatCount = 0.obs;
  Rx<Duration> _repeatEvery = Duration().obs;

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

  Future<bool> setAlarm() {
    //TODO: implement specific alarm setter
    return Future.value();
  }

  Future<void> cancelAlarm(int _id) async =>
      await Get.find<LocalNotifications>().cancelAlarmById(_id);
}
