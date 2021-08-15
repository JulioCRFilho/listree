import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class ConfigDao {
  static const String _id = 'id';

  static String get id => _id;

  static Future<Database> getOrCreateDatabase(
    String _name,
    List<String> _args, {
    int version = 1,
  }) async {
    final String _path = join(await getDatabasesPath(), '$_name.db');
    try {
      return await openDatabase(
        _path,
        onCreate: (db, version) async {
          return await db.execute('''
            create table $_name (
            id integer primary key autoincrement,
            ${_args.join(", ")}
            )''');
        },
        version: version,
      );
    } catch (e) {
      print('Error at creating table: $e');
      throw e;
    }
  }

  Future<List<Map<String, Object?>>?> getById(int _id);

  Future<List<Map<String, Object?>>?> get();

  Future<bool> insert(Map<String, dynamic> _obj);

  Future<bool> updateItem(int _id, Map<String, dynamic> _obj);

  Future<bool> delete(int _id);

  Future<void> close();
}
