import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/repository/usecases/export.dart';
import 'package:listree/settings/local_notifications/local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

abstract class Alarm {
  Rx<DateTime> _dueDate = DateTime.now().obs;

  RxInt _repeatCount = 1.obs;

  ///Getters
  DateTime get dueDate => _dueDate.value;

  String get dateTimeFormatted => [
        dueDate.day,
        dueDate.month,
        dueDate.year,
      ].join('/');

  int get repeatCount => _repeatCount.value;

  bool get dueDateValid => dueDate.isAfter(tz.TZDateTime.now(tz.local));

  ///Setters
  set dueDate(DateTime newDateTime) => _dueDate.value = newDateTime;

  set repeatCount(int value) {
    _repeatCount.value = value;
  }

  ///Methods
  @protected
  Future<void> cancelAlarm(int _id) async =>
      await Get.find<LocalNotifications>().cancelAlarmById(_id);

  @protected
  Future<void> registerAlarm(MonthlyBill _bill) async =>
      await Get.find<LocalNotifications>().scheduleNewNotification(_bill);
}
