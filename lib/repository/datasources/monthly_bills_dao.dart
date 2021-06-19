import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:listree/repository/datasources/config_dao.dart';
import 'package:listree/repository/entities/models/models.dart';
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

    //TODO: remove mock
    if (data.length == 0) {
      for (var i in Iterable.generate(9)) {
        db.insert(_table, <String, Object?>{
          'title': 'mock mesmo $i',
          'dateTime': DateTime.now().toIso8601String(),
          'repeatCount': 2 * i,
          'value': 7.20 * i,
          'pinned': i % 3 == 0,
        });
      }

      _data.value = MonthlyBill.fromList(await get() ?? []);
    }

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
        'pinned integer not null',
      ],
      version: 3,
    );
  }

  Future<void> updateData({int? id}) async {
    List<Map<String, dynamic>>? _result = await get();

    if (id != null) {
      _result = _result?.map((element) => {
        ...element,
        'showPin': element['id'] == id,
      }).toList();
    }

    _data.value = MonthlyBill.fromList(_result ?? []);
  }

  @override
  Future<bool> delete(int _id) async {
    final int _deleted = await _db
        .delete(_table, where: '${ConfigDao.id} = ?', whereArgs: [_id]);

    return _deleted == 1;
  }

  @override
  Future<List<Map<String, Object?>>?> getById(int _id) async => await db.query(
        _table,
        columns: [ConfigDao.id],
        where: '${ConfigDao.id} = ?',
        whereArgs: [_id],
      );

  @override
  Future<bool> insert(Map<String, dynamic> _obj) async {
    final int _result = await db.insert(_table, _obj);
    return _result == 1;
  }

  @override
  Future<bool> updateItem(int _id, Map<String, dynamic> _obj) async {
    final int _result = await db.update(
      _table,
      _obj,
      where: '${ConfigDao.id} = ?',
      whereArgs: [_id],
    );
    return _result == 1;
  }

  @override
  Future<void> close() async => await _db.close();

  @override
  Future<List<Map<String, Object?>>?> get() async => await db.query(_table);
}
