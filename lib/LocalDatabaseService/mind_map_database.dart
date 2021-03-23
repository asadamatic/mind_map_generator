import 'package:flutter/cupertino.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:mind_map_generator/LocalDatabaseService/local_database.dart';
import 'package:sqflite/sqflite.dart';

class MindMapDatabaseNotifier extends ChangeNotifier {
  String _tableName = 'mindMapImagesTable';
  Future insertMinMap(MindMap mindMap,) async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;

    await db.insert(
      _tableName,
      mindMap.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future updateMinMap(MindMap mindMap) async {

    // Get a reference to the database.
    final Database db = await LocalDatabase().database;

    await db.update(
      _tableName,
      mindMap.toMap(),
      where: 'docId = ?',
      whereArgs: [mindMap.docId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future deleteMinMap(String docId) async {

    // Get a reference to the database.
    final Database db = await LocalDatabase().database;

    await db.delete(
      _tableName,
      where: 'docId = ?',
      whereArgs: [docId],
    );
    notifyListeners();
  }

  Future<List<MindMap>> getMindMaps() async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;
    final List<Map<String, dynamic>> dataMap = await db.query(_tableName);
    return List.generate(dataMap.length, (i) {
      return MindMap(
          docId: dataMap[i]['docId'],
          imageFile: dataMap[i]['image'],
          name: dataMap[i]['name'],
      );
    });
  }

  MindMap fromMap(Map<String, dynamic> dataMap){

    return MindMap(
        docId: dataMap['docId'],
        imageFile: dataMap['image'],
        name: dataMap['name'],
    );
  }
}
