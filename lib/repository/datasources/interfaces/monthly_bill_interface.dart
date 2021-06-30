import 'package:listree/repository/usecases/export.dart';

abstract class MonthlyBillInterface {
  Future<bool> create();

  Future<bool> delete();

  Future<bool> update();

  Future<List<MonthlyBill>> get();
}
