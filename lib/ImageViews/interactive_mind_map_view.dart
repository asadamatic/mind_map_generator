import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';

import 'package:mind_map_generator/ListViews/document_images_grid_screen.dart';

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
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (buildContext) {
                      return Container(
                        height: 200.0,
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 8.0, right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () async {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Save to Gallery',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                        FaIcon(
                                          FontAwesomeIcons.download,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
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
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'See Original',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        FaIcon(FontAwesomeIcons.fileImage)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    });
              })
        ],
      ),
      body: Center(
        child: InteractiveViewer(child: Image(image: FileImage(imageFile))),
      ),
    );
  }
}
