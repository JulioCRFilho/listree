import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:listree/repository/entities/export.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

mixin MLocalNotifications {
  late final FlutterLocalNotificationsPlugin plugin;

  tz.Location get _localTZ => tz.local;

  NotificationDetails _notificationDetails = const NotificationDetails(
    iOS: IOSNotificationDetails(),
    macOS: MacOSNotificationDetails(),
    android: AndroidNotificationDetails(
      'androidId',
      'androidChannel',
      'Channel for android notifications',
    ),
  );

  @protected
  void initTimeZones() => tz.initializeTimeZones();

  @protected
  Future<void> cancelAlarms() async => await plugin.cancelAll();

  @protected
  Future<void> validateAlarms<T extends Alarm>(List<T> _list) async {
    try {
      final List<PendingNotificationRequest> _currentNotifications =
          await plugin.pendingNotificationRequests();

      final List<int> _expectedIds = _list.map((e) => e.id).toList();

      _expectedIds.forEach((id) async {
        final bool _idFound = _currentNotifications.any((e) => e.id == id);

        if (!_idFound || _currentNotifications.isEmpty) {
          final T _bill = _list.singleWhere((e) => e.id == id);

          if (!_bill.dueDate.isAfter(tz.TZDateTime.now(_localTZ))) return;

          await scheduleNewNotification<T>(_bill);
        }
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> cancelAlarmById(int _id) async => await plugin.cancel(_id);

  Future<void> scheduleNewNotification<T extends Alarm>(T _notification) async {
    await plugin.zonedSchedule(
      _notification.id,
      _notification.title,
      _notification.description,
      tz.TZDateTime.from(_notification.dueDate, _localTZ),
      _notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: _notification.id.toString(),
    );
  }
}
