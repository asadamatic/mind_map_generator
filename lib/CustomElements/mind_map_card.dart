import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_map_generator/Constants/functions.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/mind_map_images_notifier.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:mind_map_generator/ImageViews/interactive_mind_map_view.dart';
import 'package:provider/provider.dart';

class MindMapCard extends StatefulWidget {
  final MindMap mindMap;
  final int imageIndex;
  MindMapCard({this.mindMap, this.imageIndex});
  @override
  _MindMapCardState createState() => _MindMapCardState();
}

class _MindMapCardState extends State<MindMapCard> {
  @override
  Widget build(BuildContext context) {
    final imageFile = Provider.of<Directory>(context).path +
        widget.mindMap.imageFile;
    final isSelected = Provider.of<MindMapImagesNotifier>(context)
        .selectedMindMapIndexes
        .isNotEmpty;
    final isCurrentSelected = Provider.of<MindMapImagesNotifier>(context)
        .selectedMindMapIndexes
        .contains(widget.imageIndex);

    final String formattedDate =
        DateFormat.yMMMMEEEEd().format(DateTime.parse(DateTime.fromMicrosecondsSinceEpoch(int.parse(widget.mindMap.docId)).toString()));
    return InkWell(
      onLongPress: () {
        if (!isCurrentSelected) {
          Provider.of<MindMapImagesNotifier>(context, listen: false)
              .appendSelectedIndexes(widget.imageIndex);
        } else {
          Provider.of<MindMapImagesNotifier>(context, listen: false)
              .removeAnIndexFromSelected(widget.imageIndex);
        }
      },
      onTap: () {
        if (isSelected) {
          if (!isCurrentSelected) {
            Provider.of<MindMapImagesNotifier>(context, listen: false)
                .appendSelectedIndexes(widget.imageIndex);
          } else
          {
            Provider.of<MindMapImagesNotifier>(context, listen: false)
                .removeAnIndexFromSelected(widget.imageIndex);
          }
        } else {
          Provider.of<MindMapImagesNotifier>(context, listen: false)
              .mindMapIndex = widget.imageIndex;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (buildContext) => InteractiveMindMapView(
                        oldMindMap: widget.mindMap,
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
                    image: FileImage(File(imageFile)),
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
                        widget.mindMap.name ?? '',
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
                        Provider.of<MindMapImagesNotifier>(context,
                                listen: false)
                            .removeAnIndexFromSelected(widget.imageIndex);
                      } else {
                        Provider.of<MindMapImagesNotifier>(context,
                                listen: false)
                            .appendSelectedIndexes(widget.imageIndex);
                      }
                    })
            ],
          ),
        ),
      ),
    );
  }
}
