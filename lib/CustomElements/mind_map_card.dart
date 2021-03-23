import 'dart:convert';
import 'dart:io';

import 'package:dialogs/ChoiceDialog/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:mind_map_generator/LocalDatabaseService/mind_map_database.dart';
import 'package:mind_map_generator/ImageViews/interactive_mind_map_view.dart';
import 'package:provider/provider.dart';

class MindMapCard extends StatefulWidget {
  final MindMap mindMap;
  MindMapCard({this.mindMap});
  @override
  _MindMapCardState createState() => _MindMapCardState();
}

class _MindMapCardState extends State<MindMapCard> {
  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat.yMMMMEEEEd().format(DateTime.parse(widget.mindMap.docId));
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (buildContext) => InteractiveMindMapView(
                      mindMap: widget.mindMap,
                    )));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Container(
          height: 150.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 1 / 1.5,
                  child: Image(image: FileImage(File(widget.mindMap.imageFile)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.mindMap.name ?? '',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(formattedDate ?? '')
                    ],
                  ),
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: popUpFunction,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                  const PopupMenuItem(
                    value: 'deleteAll',
                    child: Text('Delete with images'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void popUpFunction(result) {
    showDialog(
        context: context,
        builder: (buildContext) => ChoiceDialog(
              buttonOkText: 'Yes',
              buttonOkOnPressed: () async {
                switch (result) {
                  case 'delete':
                    await Provider.of<MindMapDatabaseNotifier>(context,
                            listen: false)
                        .deleteMinMap(widget.mindMap.docId);
                    await Provider.of<DocumentsDatabaseNotifier>(context,
                            listen: false)
                        .updateDocumentStatus(widget.mindMap.docId, 0);

                    break;

                  case 'deleteAll':
                    await Provider.of<MindMapDatabaseNotifier>(context,
                            listen: false)
                        .deleteMinMap(widget.mindMap.docId);
                    await Provider.of<DocumentsDatabaseNotifier>(context,
                            listen: false)
                        .deleteDocument(widget.mindMap.docId);
                    break;
                  default:
                    break;
                }
                Navigator.pop(buildContext);
              },
              buttonCancelOnPressed: () => Navigator.pop(buildContext),
            ));
  }
}
