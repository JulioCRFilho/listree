import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:listree/repository/datasources/dao/monthly_bills_dao.dart';
import 'package:listree/repository/usecases/monthly_bill.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

mixin MLocalNotifications {
  late final FlutterLocalNotificationsPlugin plugin;

  tz.Location get localTZ => tz.local;

  NotificationDetails _notificationDetails = const NotificationDetails(
    iOS: IOSNotificationDetails(),
    macOS: MacOSNotificationDetails(),
    android: AndroidNotificationDetails(
      'androidId',
      'androidChannel',
      'Channel for android notifications',
    ),
  );

  Future<void> cancelAlarms() async => await plugin.cancelAll();

  Future<void> validateAlarms() async {
    final MonthlyBillsDAO _dao = Get.find();

    try {
      final List<PendingNotificationRequest> _currentNotifications =
          await plugin.pendingNotificationRequests();

      final List<int> _expectedIds = _dao.data.map((e) => e.id).toList();

      _expectedIds.forEach((id) async {
        final bool _idFound = _currentNotifications.any((e) => e.id == id);

        if (!_idFound || _currentNotifications.isEmpty) {
          final MonthlyBill _bill = _dao.data.singleWhere((e) => e.id == id);

          await scheduleNewNotification(_bill);
        }
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> cancelAlarmById(int _id) async => await plugin.cancel(_id);

  void initTimeZones() => tz.initializeTimeZones();

  Future<void> scheduleNewNotification(MonthlyBill _bill) async {
    await plugin.zonedSchedule(
      _bill.id,
      _bill.title,
      _bill.description,
      tz.TZDateTime.from(_bill.dueDate, localTZ),
      _notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}