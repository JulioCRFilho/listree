import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/monthly_bill/bill_widgets/bill_list.dart';
import 'package:listree/monthly_bill/monthly_bill_presenter.dart';
import 'package:listree/repository/datasources/dao/monthly_bills_dao.dart';
import 'package:listree/repository/usecases/export.dart';
import 'package:listree/settings/constants.dart';

class MonthlyBillUI extends StatelessWidget with MonthlyBillPresenter {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        backgroundColor: Colors.black54,
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            tooltip: 'Recuperar despesa excluída',
            onPressed: () async {
              final MonthlyBillsDAO dao = Get.find();

              final MonthlyBill? lastCachedBill = dao.recoverLastItemCached;

              final bool? created =
                  await lastCachedBill?.create(refreshData: true);

              if (created == true) dao.removeRecoveredCached();
              // final pendingNotifications = await Get.find<LocalNotifications>()
              //     .plugin
              //     .pendingNotificationRequests();
              // print('pending notifications: ${pendingNotifications.length}');
            },
          ),
        ],
      ),
      body: BillList(super.dao.data),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
        onPressed: () => super.createItem(),
        tooltip: 'Criar nova despesa',
      ),
    );
  }
}
