import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/ImageService/image_service.dart';
import 'package:mind_map_generator/ImageViews/interactive_image_view.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:provider/provider.dart';

class ImageCard extends StatefulWidget {
  final DocumentImage imageDocument;
  final int imageIndex;

  ImageCard({this.imageDocument, this.imageIndex});

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (result) {
                  popUpFunction(result);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 'retake',
                    child: Text('Retake'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Expanded(
                    child: AspectRatio(
                  aspectRatio: 1 / 1.5,
                  child: InkWell(
                    child: Hero(
                        tag: '${widget.imageDocument.imageId}',
                        child: Image(
                            image: FileImage(
                                File(widget.imageDocument.imageFilePath)))),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (buildContext) => InteractiveImageView(
                                  documentImage: widget.imageDocument)));
                    },
                  ),
                )),
                Text((widget.imageIndex + 1).toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void popUpFunction(result) async {
    switch (result) {
      case 'retake':
        showModalBottomSheet(
            context: context,
            builder: (buildContext) {
              return Container(
                height: 200.0,
                padding:
                    const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
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
                            final filePath = await ImageService().captureImage(
                                imageSource: ImageSource.camera,
                                buildContext: buildContext);

                            if (filePath != null) {
                              Navigator.pop(buildContext);
                              Provider.of<DocumentsDatabaseNotifier>(context,
                                      listen: false)
                                  .updateDocumentImage(DocumentImage(
                                      docId: widget.imageDocument.docId,
                                      imageFilePath: filePath,
                                      imageId: widget.imageDocument.imageId));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Camera',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                FaIcon(
                                  FontAwesomeIcons.cameraRetro,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final filePath = await ImageService().captureImage(
                                imageSource: ImageSource.gallery,
                                buildContext: buildContext);

                            if (filePath != null) {
                              Navigator.pop(buildContext);
                              Provider.of<DocumentsDatabaseNotifier>(context,
                                      listen: false)
                                  .updateDocumentImage(DocumentImage(
                                      docId: widget.imageDocument.docId,
                                      imageFilePath: filePath,
                                      imageId: widget.imageDocument.imageId));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gallery',
                                  style: Theme.of(context).textTheme.headline6,
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
        break;

      case 'delete':
        Provider.of<DocumentsDatabaseNotifier>(context, listen: false)
            .deleteDocumentImage(widget.imageDocument.imageId);
        break;
      default:
        break;
    }
  }
}
