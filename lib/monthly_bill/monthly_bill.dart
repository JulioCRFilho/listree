import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listree/settings/constants.dart';
import 'package:listree/monthly_bill/monthly_bill_presenter.dart';
import 'package:listree/monthly_bill/bill_widgets/bill_list.dart';

class MonthlyBill extends StatelessWidget with MonthlyBillPresenter {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        backgroundColor: Colors.black54,
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
