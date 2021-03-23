import 'package:flutter/material.dart';
import 'package:mind_map_generator/CustomElements/mind_map_card.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:mind_map_generator/LocalDatabaseService/mind_map_database.dart';
import 'package:mind_map_generator/ListViews/document_drafts.dart';
import 'dart:io';

import 'package:mind_map_generator/ListViews/document_images_grid_screen.dart';
import 'package:provider/provider.dart';

class MindMapsListScreen extends StatefulWidget {
  @override
  _MindMapsListScreenState createState() => _MindMapsListScreenState();
}

class _MindMapsListScreenState extends State<MindMapsListScreen> {
  File scannedDocument;
  TextEditingController hostEditingController =
      TextEditingController(text: '192.168.18.8');
  TextEditingController portEditingController =
      TextEditingController(text: '8000');

  testingFuture() async {
    await Provider.of<DocumentsDatabaseNotifier>(context, listen: false)
        .getDistinctDocs();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testingFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mind Maps'),
        actions: [
          TextButton(
            child: Text('Drafts'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DraftsListScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              TextFormField(
                controller: hostEditingController,
              ),
              TextFormField(
                controller: portEditingController,
              ),
            ],
          ),
          Expanded(
            child: Consumer<MindMapDatabaseNotifier>(
              builder: (context, value, child) {
                return FutureBuilder<List<MindMap>>(
                  future: value.getMindMaps(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return MindMapCard(
                              mindMap: snapshot.data[index],
                            );
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.camera_alt,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DocumentImagesGridScreen(
                        ipv4: hostEditingController.text.trim(),
                        port: portEditingController.text.trim(),
                        imageScreenActions: ImageScreenActions.newDocument,
                      )));
        },
      ),
    );
  }
}
