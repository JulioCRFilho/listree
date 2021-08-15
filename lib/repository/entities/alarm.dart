import 'package:get/get.dart';
import 'package:listree/settings/local_notifications/local_notifications.dart';

abstract class Alarm {
  Rx<DateTime> _dueDate = DateTime.now().obs;

  RxInt _repeatCount = 1.obs;

  DateTime get dueDate => _dueDate.value;

  String get dateTimeFormatted => [
        dueDate.day,
        dueDate.month,
        dueDate.year,
      ].join('/');

  int get repeatCount => _repeatCount.value;

  set dueDate(DateTime newDateTime) => _dueDate.value = newDateTime;

  set repeatCount(int value) {
    _repeatCount.value = value;
  }

  Future<void> cancelAlarm(int _id) async =>
      await Get.find<LocalNotifications>().cancelAlarmById(_id);
}
