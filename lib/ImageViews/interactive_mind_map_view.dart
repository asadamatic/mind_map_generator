import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';

import 'package:mind_map_generator/ListViews/document_images_grid_screen.dart';
import 'package:mind_map_generator/mind_map_editing_screen.dart';
import 'package:share/share.dart';

class InteractiveMindMapView extends StatelessWidget {
  final MindMap mindMap;

  InteractiveMindMapView({this.mindMap});

  @override
  Widget build(BuildContext context) {
    final File imageFile = File(mindMap.imageFile);

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.shareFiles(['${mindMap.imageFile}'], text: '');
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
            padding: const EdgeInsets.all(8.0),
            child: TextButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (buildContext) =>
                          DocumentImagesGridScreen(
                            id: mindMap.docId,
                            imageScreenActions:
                            ImageScreenActions
                                .fromMindMap,
                          )));
            }, child: Text('Documents', style: TextStyle(fontSize: 16.0),)),
          ),

        ],
      ),
      body: InteractiveViewer(
        child: Center(
          child: Image(image: FileImage(imageFile)),
        ),
      ),
    );
  }
}
