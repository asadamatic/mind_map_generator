import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/mind_map_images_notifier.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/server_config_notifier.dart';
import 'package:mind_map_generator/wrapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: MindMapImagesNotifier(),
          ),
          ChangeNotifierProvider.value(
            value: ServerConfigNotifier(),
          ),
          FutureProvider<Directory>.value(
            value: getApplicationDocumentsDirectory(),
            initialData: Directory(''),
          ),
        ],
        builder: (context, widget) {
          return MaterialApp(
            title: 'Mind Map Generator',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primaryColor: Colors.blue[900],
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textTheme: TextTheme()),
            home: Wrapper(),
          );
        });
  }
}
