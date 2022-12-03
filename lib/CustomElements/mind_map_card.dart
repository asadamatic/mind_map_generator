import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/mind_map_images_notifier.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:mind_map_generator/ImageViews/interactive_mind_map_view.dart';
import 'package:provider/provider.dart';

class MindMapCard extends StatelessWidget {
  final MindMap mindMap;
  final int imageIndex;
  MindMapCard({this.mindMap, this.imageIndex});
 
  @override
  Widget build(BuildContext context) {
    final imageFile = Provider.of<Directory>(context).path +
        mindMap.imageFile;
    final isSelected = Provider.of<MindMapImagesNotifier>(context)
        .selectedMindMapIndexes
        .isNotEmpty;
    final isCurrentSelected = Provider.of<MindMapImagesNotifier>(context)
        .selectedMindMapIndexes
        .contains(imageIndex);

    final String formattedDate =
        DateFormat.yMMMMEEEEd().format(DateTime.parse(DateTime.fromMicrosecondsSinceEpoch(int.parse(mindMap.docId)).toString()));
    return InkWell(
      onLongPress: () {
        if (!isCurrentSelected) {
          Provider.of<MindMapImagesNotifier>(context, listen: false)
              .appendSelectedIndexes(imageIndex);
        } else {
          Provider.of<MindMapImagesNotifier>(context, listen: false)
              .removeAnIndexFromSelected(imageIndex);
        }
      },
      onTap: () {
        if (isSelected) {
          if (!isCurrentSelected) {
            Provider.of<MindMapImagesNotifier>(context, listen: false)
                .appendSelectedIndexes(imageIndex);
          } else
          {
            Provider.of<MindMapImagesNotifier>(context, listen: false)
                .removeAnIndexFromSelected(imageIndex);
          }
        } else {
          Provider.of<MindMapImagesNotifier>(context, listen: false)
              .mindMapIndex = imageIndex;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (buildContext) => InteractiveMindMapView(

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
                        mindMap.name ?? '',
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
                            .removeAnIndexFromSelected(imageIndex);
                      } else {
                        Provider.of<MindMapImagesNotifier>(context,
                                listen: false)
                            .appendSelectedIndexes(imageIndex);
                      }
                    })
            ],
          ),
        ),
      ),
    );
  }
}
