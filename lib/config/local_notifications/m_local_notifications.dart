import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:listree/repository/datasources/monthly_bills_dao.dart';
import 'package:listree/repository/usecases/monthly_bill.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

mixin MLocalNotifications {
  late final FlutterLocalNotificationsPlugin plugin;

  Future<tz.TZDateTime> _tzDateTimeParse(DateTime _dateTime) async {
    initializeTimeZones();
    final _localTZ = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(_localTZ));

    return tz.TZDateTime.from(_dateTime, tz.local);
  }

  NotificationDetails _notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
        'androidId', 'androidChannel', 'Channel for android notifications'),
    iOS: IOSNotificationDetails(),
    macOS: MacOSNotificationDetails(),
  );

  Future<void> _show({
    required int id,
    required String title,
    required String body,
  }) async =>
      await plugin.show(id, title, body, _notificationDetails);

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async =>
      await plugin.zonedSchedule(
        id,
        title,
        body,
        await _tzDateTimeParse(dateTime),
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

  Future<void> cancelAlarms() async => await plugin.cancelAll();

  Future<void> validateAlarms() async {
    final MonthlyBillsDAO _dao = Get.find();

    try {
      final List<PendingNotificationRequest>? _currentNotifications =
          await plugin.pendingNotificationRequests();

      //TODO: current notifications empty
      print(_currentNotifications);

      final List<int> _expectedIds = _dao.data.map((e) => e.id).toList();

      _expectedIds.forEach((id) async {
        final bool _idFound =
            _currentNotifications?.every((e) => e.id == id) ?? false;

        if (!_idFound) {
          final MonthlyBill _bill = _dao.data.singleWhere((e) => e.id == id);

          for (int i = 0; i <= _bill.repeatCount; i++) {
            int _currentMonth = DateTime.now().month + i;
            if (_currentMonth > 12) _currentMonth = _currentMonth - 12;

            final Duration _currentMonthLength = _currentMonth.days;
            final DateTime _repeatDate =
                _bill.dateTime.add(_currentMonthLength);

            await plugin.zonedSchedule(
              _bill.id,
              _bill.title,
              _bill.description,
              await _tzDateTimeParse(_repeatDate),
              _notificationDetails,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              androidAllowWhileIdle: true,
            );
          }

          print('lacking notification scheduled with id $id');
        } else {
          print('no notification lacking found');
        }
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> cancelAlarmById(int _id) async => await plugin.cancel(_id);
}
