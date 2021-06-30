import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/config/constants.dart';
import 'package:listree/monthly_bill/monthly_bill.dart';
import 'package:listree/repository/datasources/monthly_bills_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(await MonthlyBillsDAO()());

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
