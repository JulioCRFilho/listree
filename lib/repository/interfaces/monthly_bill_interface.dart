import 'package:listree/repository/entities/models/models.dart';

abstract class MonthlyBillInterface {
  Future<bool> create();

  Future<bool> delete();

  Future<bool> update();

  Future<List<MonthlyBill>> get();
}
