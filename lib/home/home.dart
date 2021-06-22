import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/repository/datasources/monthly_bills_dao.dart';
import 'package:listree/repository/entities/models/models.dart';
import 'package:listree/widgets/item_view.dart';
import 'package:listree/widgets/list_items.dart';

class Home extends StatelessWidget {
  final MonthlyBillsDAO _dao = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listree'),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: ListItems(_dao.data),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: Icon(Icons.add),
        onPressed: () => createItem(),
      ),
    );
  }

  void createItem() {
    final MonthlyBill _bill = MonthlyBill();
    return ItemView(_bill, true).show();
  }
}
