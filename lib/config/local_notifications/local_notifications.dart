import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin =>
      _flutterLocalNotificationsPlugin;

  AndroidInitializationSettings _initializationSettingsAndroid =
      //TODO: implement different icons for different list types
      const AndroidInitializationSettings('@mipmap/app_icon');

  late IOSInitializationSettings _initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: _iosReceivedLocalNotification);

  MacOSInitializationSettings _initializationSettingsMacOS =
      const MacOSInitializationSettings();

  late InitializationSettings _initializationSettings = InitializationSettings(
      android: _initializationSettingsAndroid,
      iOS: _initializationSettingsIOS,
      macOS: _initializationSettingsMacOS);

  NotificationDetails _notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
        'androidId', 'androidChannel', 'Channel for android notifications'),
    iOS: IOSNotificationDetails(),
    macOS: MacOSNotificationDetails(),
  );

  Future<tz.TZDateTime> _tzDateTimeParse(DateTime _dateTime) async {
    initializeTimeZones();
    final _localTZ = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(_localTZ));

    return tz.TZDateTime.from(_dateTime, tz.local);
  }

  Future<LocalNotifications> call() async {
    try {
      await _flutterLocalNotificationsPlugin.initialize(
        _initializationSettings,
        onSelectNotification: _selectNotification,
      );
      print('local notifications inicializado');
    } catch (e) {
      throw e;
    }

    return this;
  }

  Future _selectNotification(String? payload) {
    print('notificação selecionada $payload');
    return Future.value(payload);
  }

  Future _iosReceivedLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    //TODO: implement onReceiveLocalNotification
    print('ios recebeu notificação local $id, $title, $body, $payload');
    return Future.value();
  }

  Future<void> show({
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
      );
}
