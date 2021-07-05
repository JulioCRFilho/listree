import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  Future<bool> call() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/app_icon');
    //TODO: implement different icons for different list types

    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: iosReceivedLocalNotification);

    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    final bool? _initialized = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );

    return _initialized ?? false;
  }

  Future selectNotification(String? payload) {
    print('notificação selecionada $payload');
    return Future.value(payload);
  }

  Future iosReceivedLocalNotification(
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
