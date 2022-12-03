import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/LocalDatabaseService/local_database.dart';
import 'package:sqflite/sqflite.dart';

import '../DataModels/document_image.dart';

class DocumentsDatabaseNotifier extends ChangeNotifier {
  String _tableName = 'documentImagesTable';
  DocumentsDatabaseNotifier();
  
  Future<List<DocumentImage>> getDistinctDocs() async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;

    // Query the table for all The DocumentImages.
    final List<Map<String, dynamic>> dataMap = await db.query(_tableName, groupBy: 'docId', where: 'status = ?', whereArgs: [0]);

    return List.generate(dataMap.length, (i) {
      return DocumentImage(
          docId: dataMap[i]['docId'],
          imageFilePath: dataMap[i]['image'],
          imageId: dataMap[i]['imageId'],
          status: dataMap[i]['status']
      );
    });
  }

  Future<void> insertDocumentImage(
      DocumentImage documentImage) async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;
    await db.insert(
      _tableName,
      documentImage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> updateDocumentImage(
      DocumentImage documentImage) async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;

    await db.update(
      _tableName,
      documentImage.toMap(),
      where: 'imageId = ?',
      whereArgs: [documentImage.imageId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }
  Future<void> updateDocumentStatus(
      String docId, int status) async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;

    await db.rawQuery(
      'UPDATE documentImagesTable SET status = $status WHERE docId = ?' , [docId]
    );
    notifyListeners();
  }

  Future<void> deleteDocumentImage(String imageId) async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;

    await db.delete(
      _tableName,
      where: 'imageId = ?',
      whereArgs: [imageId],
    );
    notifyListeners();
  }

  Future<void> deleteDocument(String docId) async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;

    await db.delete(
      _tableName,
      where: 'docId = ?',
      whereArgs: [docId],
    );
    notifyListeners();
  }

  Future<List<DocumentImage>> documentImages(
      String docId) async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;
    // Query the table for all The DocumentImages.
    final List<Map<String, dynamic>> dataMap =
        await db.query(_tableName, where: 'docId = ?', whereArgs: [docId]);
    // Convert the List<Map<String, dynamic> into a List<DocumentImage>.
    return List.generate(dataMap.length, (i) {
      return DocumentImage(
        docId: dataMap[i]['docId'],
        imageFilePath: dataMap[i]['image'],
        imageId: dataMap[i]['imageId'],
        status: dataMap[i]['status']
      );
    });
  }

  Future<List<String>> getImages(String docId) async {
    // Get a reference to the database.
    final Database db = await LocalDatabase().database;

    final List<Map<String, dynamic>> dataMap =
        await db.query(_tableName, columns: ['image'], where: 'docId = ?', whereArgs: [docId]);


    return Future.wait(List.generate(dataMap.length, (index) async{
      final imageFile  = File(dataMap[index]['image']);
      final bytes = await imageFile.readAsBytes();

      return base64Encode(bytes);

    }));
  }

  DocumentImage fromMap(Map<String, dynamic> dataMap){

    return DocumentImage(
        docId: dataMap['docId'],
        imageFilePath: dataMap['image'],
        imageId: dataMap['imageId'],
        status: dataMap['imageId']
    );
  }

}
