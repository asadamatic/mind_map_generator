import 'package:flutter/material.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/connection_change_notifier.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/draft_Images_notifier.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/mind_map_images_notifier.dart';
import 'package:mind_map_generator/ListViews/mind_maps_list_screen.dart';
import 'package:mind_map_generator/on_boarding_screen.dart';
import 'package:mind_map_generator/wrapper.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: ConnectionChangeNotifier(),
          ),
          ChangeNotifierProvider.value(
            value: MindMapImagesNotifier(),
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
