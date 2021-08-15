import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:listree/repository/datasources/dao/config_dao.dart';
import 'package:listree/repository/usecases/export.dart';
import 'package:sqflite/sqflite.dart';

class MonthlyBillsDAO extends GetxController with ConfigDao {
  static const String _table = 'monthly_bills';

  final RxList<MonthlyBill> _data = const <MonthlyBill>[].obs;

  late final Database _db;

  Database get db => _db;

  RxList<MonthlyBill> get data => _data;

  Future<MonthlyBillsDAO> call() async {
    _db = await _getDatabase();
    _data.value = MonthlyBill.fromList(await get() ?? []);
    return this;
  }

  Future<Database> _getDatabase() async {
    return await ConfigDao.getOrCreateDatabase(
      _table,
      [
        'title text not null',
        'description text',
        'dateTime text not null',
        'dateLimit text',
        'repeatCount integer not null',
        'value integer not null',
        'paid integer not null',
        'lastUpdate text not null',
      ],
      version: 5,
    );
  }

  Future<void> updatePaid(int _id) async {
    List<Map<String, dynamic>>? _result = await get();

    _result = _result
        ?.map((element) => {...element, 'showPaid': element['id'] == _id})
        .toList();

    _data.value = MonthlyBill.fromList(_result ?? []);
  }

  Future<void> updateData() async {
    List<Map<String, dynamic>>? _result = await get();
    _data.value = MonthlyBill.fromList(_result ?? []);
  }

  @override
  Future<bool> delete(int _id, {bool refreshData = true}) async {
    final int _deleted = await _db
        .delete(_table, where: '${ConfigDao.id} = ?', whereArgs: [_id]);

    if (_deleted == 1) {
      if (refreshData) await updateData();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Map<String, Object?>>?> getById(int _id) async => await db.query(
        _table,
        columns: [ConfigDao.id],
        where: '${ConfigDao.id} = ?',
        whereArgs: [_id],
      );

  @override
  Future<bool> insert(Map<String, dynamic> _obj,
      {bool refreshData = true}) async {
    final int _result = await db.insert(
      _table,
      _obj,
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );

    if (_result == 1) {
      if (refreshData) await updateData();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateItem(int _id, Map<String, dynamic> _obj,
      {bool refreshData = true}) async {
    final int _result = await db.update(
      _table,
      _obj,
      where: '${ConfigDao.id} = ?',
      whereArgs: [_id],
    );

    if (_result == 1) {
      if (refreshData) await updateData();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> close() async => await _db.close();

  @override
  Future<List<Map<String, Object?>>?> get() async => await db.query(_table);
}
