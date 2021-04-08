import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/document_images_notifier.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/ImageService/image_service.dart';
import 'package:mind_map_generator/CustomElements/image_card.dart';
import 'package:mind_map_generator/mind_map_generator_screen.dart';
import 'package:provider/provider.dart';

enum ImageScreenActions { newDocument, fromDraft, fromMindMap }

class DocumentImagesGridScreen extends StatefulWidget {
  final String id;
  final ImageScreenActions imageScreenActions;
  DocumentImagesGridScreen({this.imageScreenActions, this.id});

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
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: DocumentImagesNotifier(docId: id),
        builder: (buildContext, child) {
          final isSelected = Provider.of<DocumentImagesNotifier>(buildContext)
              .selectedDocumentImagesIndexes
              .isNotEmpty;
          final isOnlyCurrentSelected =
              Provider.of<DocumentImagesNotifier>(buildContext)
                      .selectedDocumentImagesIndexes
                      .length ==
                  1;
          return WillPopScope(
            onWillPop: () async {
              if (isSelected) {
                Provider.of<DocumentImagesNotifier>(buildContext, listen: false)
                    .removeAllSelectedIndexes();
                return false;
              } else {
                return true;
              }
            },
            child: GestureDetector(
              onTap: () {
                if (isSelected) {
                  Provider.of<DocumentImagesNotifier>(buildContext,
                          listen: false)
                      .removeAllSelectedIndexes();
                  return false;
                } else {
                  return true;
                }
              },
              child: Scaffold(
                appBar: AppBar(
                    title: Text(widget.imageScreenActions ==
                            ImageScreenActions.newDocument
                        ? 'New Document'
                        : 'Document Images'),
                    actions: isSelected
                        ? [
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Provider.of<DocumentImagesNotifier>(
                                          buildContext,
                                          listen: false)
                                      .deleteAllSelected();
                                }),
                            if (isOnlyCurrentSelected)
                              IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (bottomSheetContext) {
                                          return Container(
                                            height: 200.0,
                                            padding: const EdgeInsets.only(
                                                top: 15.0,
                                                left: 8.0,
                                                right: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Select an image of your documents!',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                                Divider(),
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        final filePath =
                                                            await ImageService()
                                                                .captureImage(
                                                                    imageSource:
                                                                        ImageSource
                                                                            .camera,
                                                                    buildContext:
                                                                        buildContext);

                                                        if (filePath != null) {
                                                          Navigator.pop(
                                                              bottomSheetContext);
                                                          Provider.of<DocumentImagesNotifier>(
                                                                  buildContext,
                                                                  listen: false)
                                                              .update(filePath);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text('Camera',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6),
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .cameraRetro,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        final filePath =
                                                            await ImageService()
                                                                .captureImage(
                                                                    imageSource:
                                                                        ImageSource
                                                                            .gallery,
                                                                    buildContext:
                                                                        buildContext);

                                                        if (filePath != null) {
                                                          Navigator.pop(
                                                              bottomSheetContext);
                                                          Provider.of<DocumentImagesNotifier>(
                                                                  buildContext,
                                                                  listen: false)
                                                              .update(filePath);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Gallery',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6,
                                                            ),
                                                            FaIcon(
                                                                FontAwesomeIcons
                                                                    .photoVideo)
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
                                  }),
                          ]
                        : []),
                body: Consumer<DocumentImagesNotifier>(
                  builder: (context, value, child) {
                    if (value != null) {
                      return GridView.builder(
                          itemCount: value.documentImages?.length ?? 0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? 2
                                          : 3),
                          itemBuilder: (context, index) {
                            return ImageCard(
                                imageDocument: value.documentImages[index],
                                imageIndex: index);
                          });
                    }

                    return Center();
                  },
                ),
                floatingActionButton: FloatingButtons(
                  id: id,
                  imageScreenActions: widget.imageScreenActions,
                ),
              ),
            ),
          );
        });
  }
}

// ignore: must_be_immutable
class FloatingButtons extends StatelessWidget {
  final ImageScreenActions imageScreenActions;
  FloatingButtons(
      {@required this.id, this.imageScreenActions, this.port, this.ipv4});

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
                if (Provider.of<DocumentImagesNotifier>(context, listen: false)
                        .documentImages
                        .length ==
                    0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'Please scan your docs first!',
                    style: TextStyle(fontSize: 18.0),
                  )));
                } else {
                  final images = await Future.wait(
                      Provider.of<DocumentImagesNotifier>(context,
                          listen: false)
                          .documentImages
                          .map((documentImage) async {
                        final file = File(documentImage.imageFilePath);
                        final bytes = await file.readAsBytes();
                        return base64Encode(bytes);
                      }));
                  if (imageScreenActions == ImageScreenActions.fromDraft ||
                      imageScreenActions == ImageScreenActions.newDocument) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MindMapGeneratorScreen(
                                  base64EncodedImages: images,
                                  docId: id,
                                  mapScreenActions:
                                      MindMapGeneratorScreenActions.insert,
                                )));
                  } else if (imageScreenActions ==
                      ImageScreenActions.fromMindMap) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MindMapGeneratorScreen(
                                  base64EncodedImages: images,
                                  docId: id,
                                  mapScreenActions:
                                      MindMapGeneratorScreenActions.update,
                                )));
                  }
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
                                  final filePath = await ImageService()
                                      .captureImage(
                                          imageSource: ImageSource.camera,
                                          buildContext: buildContext);

                                  if (filePath != null) {
                                    Navigator.pop(buildContext);
                                    await Provider.of<DocumentImagesNotifier>(
                                            context,
                                            listen: false)
                                        .append(
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
                                  final filePath = await ImageService()
                                      .captureImage(
                                          imageSource: ImageSource.gallery,
                                          buildContext: buildContext);

                                  if (filePath != null) {
                                    Navigator.pop(buildContext);
                                    await Provider.of<DocumentImagesNotifier>(
                                            context,
                                            listen: false)
                                        .append(
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
