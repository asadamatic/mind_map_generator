import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static const _databaseName = 'final_database_test.db';
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
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), _databaseName),
      // When the database is first created, create a table to store DocumentImages.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return _createDb(db);
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  static void _createDb(Database db) {
    db.execute(
        "CREATE TABLE documentImagesTable(docId TEXT, image TEXT, imageId TEXT PRIMARY KEY, status INTEGER)");
    db.execute(
        "CREATE TABLE mindMapImagesTable(docId TEXT PRIMARY KEY, image TEXT, name TEXT)");
  }
}
