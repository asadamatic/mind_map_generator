import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/ImageService/image_service.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:mind_map_generator/CustomElements/image_card.dart';
import 'package:mind_map_generator/mind_map_generator_screen.dart';
import 'package:provider/provider.dart';

enum ImageScreenActions { newDocument, fromDraft, fromMindMap }

class DocumentImagesGridScreen extends StatefulWidget {
  final String ipv4, port, id;
  final ImageScreenActions imageScreenActions;
  DocumentImagesGridScreen(
      {this.ipv4, this.port, this.imageScreenActions, this.id});

  @override
  _DocumentImagesGridScreenState createState() =>
      _DocumentImagesGridScreenState();
}

class _DocumentImagesGridScreenState extends State<DocumentImagesGridScreen> {
  String id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.imageScreenActions == ImageScreenActions.newDocument) {
      id = DateTime.now().toString();
    } else if (widget.imageScreenActions == ImageScreenActions.fromMindMap ||
        widget.imageScreenActions == ImageScreenActions.fromDraft) {
      id = widget.id;
    }

    print('*********');

    print('*********');

    print('*********');

    print('*********');
    print(id);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(DateTime.now().toString() ?? 'MindMap'),
      ),
      body: Consumer<DocumentsDatabaseNotifier>(
        builder: (context, value, child) {
          return FutureBuilder<List<DocumentImage>>(
              future: value.documentImages(id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      itemCount: snapshot.data.length ?? 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? 2
                              : 3),
                      itemBuilder: (context, index) {
                        return ImageCard(
                            imageDocument: snapshot.data[index],
                            imageIndex: index);
                      });
                }
                return CircularProgressIndicator();
              });
        },
      ),
      floatingActionButton: FloatingButtons(
        id: id,
        imageScreenActions: widget.imageScreenActions,
        port: widget.port,
        ipv4: widget.ipv4,
      ),
    );
  }
}

// ignore: must_be_immutable
class FloatingButtons extends StatelessWidget {
  final ImageScreenActions imageScreenActions;
  FloatingButtons({@required this.id, this.imageScreenActions, this.port, this.ipv4});

  final String id;
  final String ipv4, port;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: FloatingActionButton(
              heroTag: 'doneButton',
              backgroundColor: Colors.white,
              child: Icon(
                Icons.done,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                List<String> images =
                    await Provider.of<DocumentsDatabaseNotifier>(context,
                            listen: false)
                        .getImages(id);
                if (imageScreenActions == ImageScreenActions.fromDraft ||
                    imageScreenActions == ImageScreenActions.newDocument) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MindMapGeneratorScreen(
                                port: port,
                                ipv4: ipv4,
                                base64EncodedImages: images,
                                docId: id,
                                mapScreenActions: MindMapGeneratorScreenActions.insert,
                              )));
                } else if (imageScreenActions ==
                    ImageScreenActions.fromMindMap) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MindMapGeneratorScreen(
                                port: port,
                                ipv4: ipv4,
                                base64EncodedImages: images,
                                docId: id,
                                mapScreenActions: MindMapGeneratorScreenActions.update,
                              )));
                }
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: FloatingActionButton(
            heroTag: 'addImageButton',
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add,
            ),
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
                          Text(
                            'Select an image of your documents!',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Divider(),
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final filePath =
                                      await ImageService().captureImage(
                                          imageSource: ImageSource.camera,
                                          buildContext: buildContext);

                                  if (filePath != null) {
                                    print(filePath);
                                    Navigator.pop(buildContext);
                                    await Provider.of<DocumentsDatabaseNotifier>(
                                            context,
                                            listen: false)
                                        .insertDocumentImage(
                                      DocumentImage(
                                          docId: id,
                                          imageFilePath: filePath,
                                          imageId: DateTime.now().toString(),
                                          status: 0),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Camera',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      FaIcon(
                                        FontAwesomeIcons.cameraRetro,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final filePath =
                                      await ImageService().captureImage(
                                          imageSource: ImageSource.gallery,
                                          buildContext: buildContext);

                                  if (filePath != null) {
                                    Navigator.pop(buildContext);
                                    await Provider.of<DocumentsDatabaseNotifier>(
                                            context,
                                            listen: false)
                                        .insertDocumentImage(
                                      DocumentImage(
                                          docId: id,
                                          imageFilePath: filePath,
                                          imageId: DateTime.now().toString(),
                                          status: 0),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Gallery',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      FaIcon(FontAwesomeIcons.photoVideo)
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
            },
          ),
        ),
      ],
    );
  }
}
