import 'package:get/get.dart';
import 'package:listree/repository/datasources/monthly_bills_dao.dart';
import 'package:listree/repository/usecases/export.dart';
import 'package:listree/widgets/item_view.dart';

mixin MonthlyBillPresenter {
  final MonthlyBillsDAO dao = Get.find();

  void createItem() {
    final MonthlyBill _bill = MonthlyBill();
    return ItemView(_bill, true).show();
  }
}