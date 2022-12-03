import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/document_images_notifier.dart';
import 'package:mind_map_generator/CustomElements/image_card.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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
      id = DateTime.now().microsecondsSinceEpoch.toString();
    } else if (widget.imageScreenActions == ImageScreenActions.fromMindMap ||
        widget.imageScreenActions == ImageScreenActions.fromDraft) {
      id = widget.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String directoryPath = Provider.of<Directory>(context).path;
    return ChangeNotifierProvider.value(
        value: DocumentImagesNotifier(
            docId: id, imageScreenActions: widget.imageScreenActions),
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
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Provider.of<DocumentImagesNotifier>(
                                          buildContext,
                                          listen: false)
                                      .shareSelected(directoryPath);
                                }),
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
                                                        Provider.of<DocumentImagesNotifier>(
                                                                buildContext,
                                                                listen: false)
                                                            .updateDocumentImage(
                                                                buildContext,
                                                                bottomSheetContext,
                                                                ImageSource
                                                                    .camera);
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
                                                        Provider.of<DocumentImagesNotifier>(
                                                                buildContext,
                                                                listen: false)
                                                            .updateDocumentImage(
                                                                buildContext,
                                                                bottomSheetContext,
                                                                ImageSource
                                                                    .gallery);
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
                        : [
                            IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Share.shareFiles(
                                      Provider.of<DocumentImagesNotifier>(
                                              buildContext,
                                              listen: false)
                                          .documentImagePaths
                                          .map((e) =>
                                              File(directoryPath.toString() + e)
                                                  .path)
                                          .toList(),
                                      text: '');
                                }),
                          ]),
                body: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Consumer<DocumentImagesNotifier>(
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

class FloatingButtons extends StatelessWidget {
  final ImageScreenActions imageScreenActions;
  FloatingButtons(
      {@required this.id, this.imageScreenActions, this.port, this.ipv4});

  final String id;
  final String ipv4, port;

  @override
  Widget build(BuildContext context) {
    final directoryPath = Provider.of<Directory>(context).path;
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
                Provider.of<DocumentImagesNotifier>(context, listen: false)
                    .proceedToGenerate(context, directoryPath);
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
                                  Provider.of<DocumentImagesNotifier>(context,
                                          listen: false)
                                      .getDocumentImage(
                                          buildContext, ImageSource.camera);
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
                                  Provider.of<DocumentImagesNotifier>(context,
                                          listen: false)
                                      .getDocumentImage(
                                          buildContext, ImageSource.gallery);
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
