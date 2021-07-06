import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listree/config/constants.dart';
import 'package:listree/monthly_bill/monthly_bill_presenter.dart';
import 'package:listree/widgets/list_items.dart';

class MonthlyBill extends StatelessWidget with MonthlyBillPresenter {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: ListItems(super.dao.data),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
        onPressed: () => super.createItem(),
      ),
    );
  }
}
