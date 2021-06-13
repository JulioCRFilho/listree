import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class ConfigDao {
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
          '$_name(id INTEGER PRIMARY KEY AUTOINCREMENT, '
          '${_args.join(", ")}'
          ')',
        );
      },
      version: version,
    );
  }
}
