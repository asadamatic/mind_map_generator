import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:mind_map_generator/LocalDatabaseService/mind_map_database.dart';
import 'package:mind_map_generator/NetworkService/network_service.dart';
import 'package:provider/provider.dart';

enum MindMapGeneratorScreenActions { insert, update }

class MindMapGeneratorScreen extends StatefulWidget {
  final List<String> base64EncodedImages;
  final String ipv4;
  final String port;
  final String docId;
  final MindMapGeneratorScreenActions mapScreenActions;

  MindMapGeneratorScreen(
      {this.docId,
      this.port,
      this.base64EncodedImages,
      this.ipv4,
      this.mapScreenActions});

  @override
  _MindMapGeneratorScreenState createState() => _MindMapGeneratorScreenState();
}

class _MindMapGeneratorScreenState extends State<MindMapGeneratorScreen> {


  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget?.docId.toString()),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          child: Container(
                            height: 200.0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Name Your Mind Map'),
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      hintText: 'mind map name'),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: FlatButton(
                                          child: Text(
                                            'Cancel',
                                          ),
                                          textColor:
                                              Theme.of(context).primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )),
                                    Spacer(flex: 1),
                                    Expanded(
                                        flex: 5,
                                        child: FlatButton(
                                          child: Text(
                                            'Done',
                                          ),
                                          textColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
              })
        ],
      ),
      body: FutureBuilder<String>(
        future: NetworkService(ipv4: widget.ipv4, port: widget.port)
            .connectToServer(widget.base64EncodedImages, widget.docId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final File imageFile = File(snapshot.data);
            return Column(
              children: [
                Expanded(
                  child: InteractiveViewer(
                    child: AspectRatio(
                      aspectRatio: 1 / 1.5,
                      child: Image(image: FileImage(imageFile)),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ElevatedButton(
                              child: Text('Discard'),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1.5),
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(color: Colors.white))),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ElevatedButton(
                              child: Text('Save'),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1.5),
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(color: Colors.white))),
                              onPressed: () async {
                                if (widget.mapScreenActions ==
                                    MindMapGeneratorScreenActions.insert) {
                                  await Provider.of<MindMapDatabaseNotifier>(
                                          context,
                                          listen: false)
                                      .insertMinMap(MindMap(
                                          docId: widget.docId,
                                          imageFile: snapshot.data,
                                          name: nameController.text.isEmpty
                                              ? widget.docId
                                              : nameController.text ??
                                                  widget.docId));
                                } else if (widget.mapScreenActions ==
                                    MindMapGeneratorScreenActions.update) {
                                  await Provider.of<MindMapDatabaseNotifier>(
                                          context,
                                          listen: false)
                                      .updateMinMap(MindMap(
                                          docId: widget.docId,
                                          imageFile: snapshot.data,
                                          name: nameController.text.isEmpty
                                              ? widget.docId
                                              : nameController.text));
                                }
                                await Provider.of<DocumentsDatabaseNotifier>(
                                        context,
                                        listen: false)
                                    .updateDocumentStatus(widget.docId, 1);
                                Navigator.pop(context);
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
