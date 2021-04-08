import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/draft_Images_notifier.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/ListViews/document_images_grid_screen.dart';
import 'package:provider/provider.dart';

class DraftCard extends StatefulWidget {
  final DocumentImage documentImage;
  final int draftIndex;
  DraftCard({this.documentImage, this.draftIndex});
  @override
  _DraftCardState createState() => _DraftCardState();
}

class _DraftCardState extends State<DraftCard> {
  @override
  Widget build(BuildContext context) {
    final isSelected = Provider.of<DraftImagesNotifier>(context)
        .selectedDraftIndexes
        .isNotEmpty;
    final isCurrentSelected = Provider.of<DraftImagesNotifier>(context)
        .selectedDraftIndexes
        .contains(widget.draftIndex);
    final String formattedDate = DateFormat.yMMMMEEEEd()
        .format(DateTime.parse(widget.documentImage.docId));
    return InkWell(
      onLongPress: () {
        if (!isCurrentSelected) {
          Provider.of<DraftImagesNotifier>(context, listen: false)
              .appendSelectedIndexes(widget.draftIndex);
        }else{
          Provider.of<DraftImagesNotifier>(context, listen: false)
              .removeAnIndexFromSelected(widget.draftIndex);
        }
      },
      onTap: () {
        if (isSelected) {
          if (!isCurrentSelected) {
            Provider.of<DraftImagesNotifier>(context, listen: false)
                .appendSelectedIndexes(widget.draftIndex);
          } else {
            Provider.of<DraftImagesNotifier>(context, listen: false)
                .removeAnIndexFromSelected(widget.draftIndex);
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (buildContext) => DocumentImagesGridScreen(
                        id: widget.documentImage.docId,
                        imageScreenActions: ImageScreenActions.fromDraft,
                      )));
        }
      },
      child: Card(
        shadowColor: isCurrentSelected ? Colors.grey[500] : null,
        elevation: isCurrentSelected ? 8.0 : 2.0,
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Container(
          height: 150.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 1 / 1.5,
                  child: Image(
                    image: FileImage(File(widget.documentImage.imageFilePath)),
                    fit: BoxFit.cover,
                  )),
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
              if (isSelected)
                Checkbox(
                    value: isCurrentSelected ? true : false,
                    onChanged: (value) {
                      if (isCurrentSelected) {
                        Provider.of<DraftImagesNotifier>(context, listen: false)
                            .removeAnIndexFromSelected(widget.draftIndex);
                      } else {
                        Provider.of<DraftImagesNotifier>(context, listen: false)
                            .appendSelectedIndexes(widget.draftIndex);
                      }
                    })
            ],
          ),
        ),
      ),
    );
  }
}
