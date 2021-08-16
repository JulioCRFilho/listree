import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:listree/monthly_bill/bill_widgets/bill_viewer.dart';
import 'package:listree/repository/datasources/dao/monthly_bills_dao.dart';
import 'package:listree/repository/usecases/export.dart';
import 'package:listree/settings/local_notifications/m_local_notifications.dart';

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

      super.initTimeZones();

      await super.plugin.initialize(
            _initializationSettings,
            onSelectNotification: _selectNotification,
          );

      await super.validateAlarms();
    } catch (e) {
      throw e;
    }

    return this;
  }

  Future<void> _selectNotification(String? _id) async {
    if (_id == null || _id.isEmpty) return;

    final MonthlyBillsDAO _dao = Get.find();
    final Map<String,dynamic> _billMap = await _dao.getById(int.parse(_id));
    final MonthlyBill _selectedBill = MonthlyBill.fromMap(_billMap);

    _selectedBill.updatePaid(false, refreshData: false);
    BillViewer(_selectedBill, notification: true).show();
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
