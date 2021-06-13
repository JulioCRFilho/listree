import 'package:listree/repository/datasources/config_dao.dart';
import 'package:sqflite/sqflite.dart';

class MonthlyBillsDAO extends ConfigDao {
  static const String _table = 'monthly_bills.db';

  Database? _db;

  Database? get db => _db;

  void call() async => _db = await _getDatabase();

  Future<Database> _getDatabase() async {
    return await ConfigDao.getOrCreateDatabase(_table, [
      'title TEXT',
      'description TEXT',
      'dateTime DATETIME',
      'dateLimit DATETIME',
      'repeat BOOLEAN',
      'repeatCount INTEGER',
      'value DOUBLE',
    ]);
  }

  @override
  Future<bool> delete(int _id) async {
    final int _deleted = await _db
            ?.delete(_table, where: '${ConfigDao.id} = ?', whereArgs: [_id]) ??
        0;

    return _deleted == 1;
  }

  @override
  Future<List<Map<String, Object?>>?> getById(int _id) async => await db?.query(
        _table,
        columns: [ConfigDao.id],
        where: '${ConfigDao.id} = ?',
        whereArgs: [_id],
      );

  @override
  Future<bool> insert(Map<String, dynamic> _obj) async {
    final int _result = await db?.insert(_table, _obj) ?? 0;
    return _result == 1;
  }

  @override
  Future<bool> update(int _id, Map<String, dynamic> _obj) async {
    final int _result = await db?.update(_table, _obj) ?? 0;
    return _result == 1;
  }

  @override
  Future<void> close() async => await _db?.close();
}
