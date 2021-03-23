import 'package:flutter/material.dart';
import 'package:mind_map_generator/LocalDatabaseService/local_database.dart';
import 'package:mind_map_generator/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterGeniusScan.setLicenceKey('533c5006555105000954045239525a0e4a0f570355554b550e551a0b5e56546c0f5514116704000652070002535105');

  LocalDatabase().initializeDocumentsTable();
  runApp(MyApp());
}

