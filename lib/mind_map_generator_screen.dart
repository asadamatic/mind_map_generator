import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/connection_change_notifier.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/mind_map_images_notifier.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/server_config_notifier.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:mind_map_generator/NetworkService/network_service.dart';
import 'package:provider/provider.dart';

enum MindMapGeneratorScreenActions { insert, update, reCreate }

class MindMapGeneratorScreen extends StatefulWidget {
  final List<String> base64EncodedImages;
  final List<String> listOfData;
  final String docId;
  final MindMapGeneratorScreenActions mapScreenActions;

  MindMapGeneratorScreen(
      {this.docId,
      this.base64EncodedImages,
      this.mapScreenActions,
      this.listOfData});

  @override
  _MindMapGeneratorScreenState createState() => _MindMapGeneratorScreenState();
}

class _MindMapGeneratorScreenState extends State<MindMapGeneratorScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final directoryPath = Provider.of<Directory>(context).path;
    final ipv4 =
        Provider.of<ServerConfigNotifier>(context, listen: false).host;
    final port =
        Provider.of<ServerConfigNotifier>(context, listen: false).port;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mind Map'),
      ),
      body: FutureBuilder<MindMap>(
        future:
            widget.mapScreenActions == MindMapGeneratorScreenActions.reCreate
                ? NetworkService(ipv4: ipv4, port: port)
                    .editMindMap(widget.listOfData, widget.docId)
                : NetworkService(ipv4: ipv4, port: port)
                    .generateMindMap(widget.base64EncodedImages, widget.docId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            return Column(
              children: [
                Expanded(
                  child: InteractiveViewer(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 1 / 1.5,
                        child: Image(image: FileImage(File(Provider.of<Directory>(context).path + snapshot.data.imageFile))),
                      ),
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
                              child: Text('Discard', style: TextStyle(color: Theme.of(context).primaryColor),),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1.5),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))),
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
                                  Provider.of<MindMapImagesNotifier>(context,
                                          listen: false)
                                      .append(snapshot.data);

                                  await GallerySaver.saveImage(
                                      directoryPath + snapshot.data.imageFile);
                                } else if (widget.mapScreenActions ==
                                        MindMapGeneratorScreenActions.update ||
                                    widget.mapScreenActions ==
                                        MindMapGeneratorScreenActions
                                            .reCreate) {
                                  Provider.of<MindMapImagesNotifier>(context,
                                          listen: false)
                                      .updateMindMap(snapshot.data);
                                  await GallerySaver.saveImage(
                                      directoryPath + snapshot.data.imageFile);
                                }

                                DocumentsDatabaseNotifier()
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
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
                child: Text('Please wait, while we are generating mind map for You :)'),
              )
            ],
          ));
        },
      ),
    );
  }
}
