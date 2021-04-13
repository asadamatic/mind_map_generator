import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/mind_map_images_notifier.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';

import 'package:mind_map_generator/ListViews/document_images_grid_screen.dart';
import 'package:mind_map_generator/mind_map_editing_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class InteractiveMindMapView extends StatelessWidget {
  final MindMap oldMindMap;

  InteractiveMindMapView({this.oldMindMap});

  @override
  Widget build(BuildContext context) {
    final mindMap = Provider.of<MindMapImagesNotifier>(context).mindMaps[Provider.of<MindMapImagesNotifier>(context).mindMapIndex];
    final File imageFile =
        File(Provider.of<Directory>(context).path + mindMap.imageFile);
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              print(mindMap.imageFile);
              Share.shareFiles([imageFile.path], text: '');
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (buildContext) => MindMapEditingScreen(
                          mindMap: mindMap,
                          docId: mindMap.docId,
                          listOfData: (jsonDecode(mindMap.text) as List)
                              ?.map((e) => e as String)
                              ?.toList())));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (buildContext) => DocumentImagesGridScreen(
                              id: mindMap.docId,
                              imageScreenActions:
                                  ImageScreenActions.fromMindMap,
                            )));
              },
            ),
          ),
        ],
      ),
      body: InteractiveViewer(
        child: Center(child: Image(image: FileImage(imageFile))),
      ),
    );
  }
}
