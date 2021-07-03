import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  //TODO: implement the drawable 'app_icon'

  static IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(onDidReceiveLocalNotification: (a, b, c, d) {
    //TODO: implement onReceiveLocalNotification
    return Future.value();
  });

  static MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();

  static InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);

  static Future<bool> call() async {
    final bool? _initialized = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (_) {
        //TODO: implement onSelectNotification
        return Future.value();
      },
    );

    return _initialized ?? false;
  }
}
