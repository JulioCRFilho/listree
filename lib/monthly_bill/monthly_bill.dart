import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/monthly_bill/bill_widgets/bill_list.dart';
import 'package:listree/monthly_bill/monthly_bill_presenter.dart';
import 'package:listree/settings/constants.dart';
import 'package:listree/settings/local_notifications/local_notifications.dart';

class MonthlyBill extends StatelessWidget with MonthlyBillPresenter {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        backgroundColor: Colors.black54,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              final pendingNotifications = await Get.find<LocalNotifications>()
                  .plugin
                  .pendingNotificationRequests();
                print(pendingNotifications.length);
            },
          ),
        ],
      ),
      body: BillList(super.dao.data),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
        onPressed: () => super.createItem(),
      ),
    );
  }
}
