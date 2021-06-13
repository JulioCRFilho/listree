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
    final String _path = join(await getDatabasesPath(), _name);
    return await openDatabase(
      _path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE '
          '$_name($id INTEGER PRIMARY KEY AUTOINCREMENT, '
          '${_args.join(", ")}'
          ')',
        );
      },
      version: version,
    );
  }

  Future<List<Map<String, Object?>>?> getById(int _id);

  Future<bool> insert(Map<String, dynamic> _obj);

  Future<bool> update(int _id, Map<String, dynamic> _obj);

  Future<bool> delete(int _id);

  Future<void> close();
}
