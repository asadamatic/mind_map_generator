import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static const _databaseName = 'newoldnew.db';
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDocumentsTable();
    } else {
      return _database;
    }
  }

  initializeDocumentsTable() async {
    return await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) {
        return _createDb(db);
      },
      version: 1,
    );
  }

  static void _createDb(Database db) {
    db.execute(
        "CREATE TABLE documentImagesTable(docId TEXT, image TEXT, imageId TEXT PRIMARY KEY, status INTEGER)");
    db.execute(
        "CREATE TABLE mindMapImagesTable(docId TEXT PRIMARY KEY, image TEXT, name TEXT, text TEXT)");
  }
}
