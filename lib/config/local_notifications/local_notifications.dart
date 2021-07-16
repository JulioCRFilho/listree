import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:listree/config/local_notifications/m_local_notifications.dart';

class LocalNotifications with MLocalNotifications {
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

  Future<LocalNotifications> call() async {
    try {
      super.plugin = FlutterLocalNotificationsPlugin();
      final _initialized = await super.plugin.initialize(
            _initializationSettings,
            onSelectNotification: _selectNotification,
          );

      await super.validateAlarms();
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
}
