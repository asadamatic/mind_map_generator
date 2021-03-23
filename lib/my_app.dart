import 'package:flutter/material.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:mind_map_generator/LocalDatabaseService/mind_map_database.dart';
import 'package:mind_map_generator/ListViews/mind_maps_list_screen.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<DocumentsDatabaseNotifier>.value(
            value: DocumentsDatabaseNotifier(),
          ),
          ChangeNotifierProvider<MindMapDatabaseNotifier>.value(
            value: MindMapDatabaseNotifier(),
          ),
        ],
        builder: (context, widget) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.blue[900],
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textTheme: TextTheme()),
            home: MindMapsListScreen(),
          );
        });
  }
}
