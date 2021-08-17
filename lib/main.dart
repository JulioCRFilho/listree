import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/settings/constants.dart';
import 'package:listree/settings/local_notifications/local_notifications.dart';
import 'package:listree/monthly_bill/monthly_bill.dart';
import 'package:listree/repository/datasources/dao/monthly_bills_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //TODO: refactor de DAOs' initialization and insertion based on flow
  Get.put(await MonthlyBillsDAO()());
  Get.put(await LocalNotifications()());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      home: MonthlyBill(),
    );
  }
}
