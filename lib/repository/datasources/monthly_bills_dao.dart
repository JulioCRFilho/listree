import 'package:listree/repository/datasources/config_dao.dart';
import 'package:sqflite/sqflite.dart';

class MonthlyBillsDAO extends ConfigDao {
  Future<Database> getDatabase() async {
    return await ConfigDao.getOrCreateDatabase('monthly_bills.db', [
      'title TEXT',
      'description TEXT',
      'dateTime DATETIME',
      'dateLimit DATETIME',
      'repeat BOOLEAN',
      'repeatCount INTEGER',
      'value DOUBLE',
    ]);
  }
}
