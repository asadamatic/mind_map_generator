import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/ListViews/document_images_grid_screen.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:mind_map_generator/LocalDatabaseService/mind_map_database.dart';
import 'package:provider/provider.dart';

class DraftCard extends StatefulWidget {
  final DocumentImage documentImage;
  DraftCard({this.documentImage});
  @override
  _DraftCardState createState() => _DraftCardState();
}

class _DraftCardState extends State<DraftCard> {
  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat.yMMMMEEEEd()
        .format(DateTime.parse(widget.documentImage.docId));
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (buildContext) => DocumentImagesGridScreen(
                      id: widget.documentImage.docId,
                      imageScreenActions: ImageScreenActions.fromDraft,
                    )));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
          height: 150.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 1 / 1.5,
                  child: Image(
                      image:
                          FileImage(File(widget.documentImage.imageFilePath)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.documentImage.docId ?? '',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(formattedDate ?? '')
                    ],
                  ),
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: popMenuFunctions,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  popMenuFunctions(result) async {
    switch (result) {
      case 'delete':
        await Provider.of<DocumentsDatabaseNotifier>(context, listen: false)
            .deleteDocument(widget.documentImage.docId);

        break;

      default:
        break;
    }
  }
}
