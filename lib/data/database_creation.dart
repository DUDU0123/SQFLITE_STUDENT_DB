import 'package:sqflite/sqflite.dart';

class DataBaseCreation {
  Future<Database> createDB() async {
    var _db = await openDatabase(
      'db_storage.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE studentdb (id INTEGER PRIMARY KEY, name TEXT, age TEXT, place TEXT, standard TEXT, profileimage BLOB)');
      },
    );
    return _db;
  }
}
