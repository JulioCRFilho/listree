import 'package:get/get.dart';
import 'package:listree/repository/datasources/dao/monthly_bills_dao.dart';
import 'package:listree/repository/usecases/export.dart';
import 'package:listree/monthly_bill/bill_widgets/bill_viewer.dart';

mixin MonthlyBillPresenter {
  final MonthlyBillsDAO dao = Get.find();

  void createItem() {
    final MonthlyBill _bill = MonthlyBill();
    return BillViewer(_bill, creating: true).show();
  }
}