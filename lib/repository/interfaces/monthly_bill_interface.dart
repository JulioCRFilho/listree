import 'package:listree/repository/datasources/monthly_bills_dao.dart';
import 'package:listree/repository/entities/models/models.dart';

abstract class MonthlyBillInterface {
  Future<bool> create();

  Future<bool> delete();

  Future<bool> update();

  Future<List<MonthlyBill>> get();
}
