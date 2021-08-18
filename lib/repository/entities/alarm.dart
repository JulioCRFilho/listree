import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/repository/entities/export.dart';
import 'package:listree/settings/local_notifications/local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

abstract class Alarm with Savable {
  Rx<DateTime> _dueDate = DateTime.now().obs;

  RxInt _repeatCount = 1.obs;

  ///Getters
  DateTime get dueDate => _dueDate.value;

  Rx<DateTime> get dueDateObs => _dueDate;

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

  Future<void> registerAlarm<T extends Alarm>(T _notification) async =>
      await Get.find<LocalNotifications>().scheduleNewNotification<T>(_notification);
}
