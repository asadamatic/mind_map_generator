import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mind_map_generator/CustomChangeNotifiers/document_images_notifier.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/ImageViews/images_sllider.dart';
import 'package:provider/provider.dart';

class ImageCard extends StatelessWidget {
  final DocumentImage imageDocument;
  final int imageIndex;

  ImageCard({this.imageDocument, this.imageIndex});

  @override
  Widget build(BuildContext context) {
    final imageFile = Provider.of<Directory>(context).path + imageDocument.imageFilePath;
    final isSelected = Provider.of<DocumentImagesNotifier>(context)
        .selectedDocumentImagesIndexes
        .isNotEmpty;
    final isCurrentSelected = Provider.of<DocumentImagesNotifier>(context)
        .selectedDocumentImagesIndexes
        .contains(imageIndex);
    final documentImages = Provider.of<DocumentImagesNotifier>(context).documentImages;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onLongPress: () {
                      {
                        if (!isCurrentSelected) {
                          Provider.of<DocumentImagesNotifier>(context, listen: false)
                              .appendSelectedIndexes(imageIndex);
                        } else {
                          Provider.of<DocumentImagesNotifier>(context, listen: false)
                              .removeAnIndexFromSelected(imageIndex);
                        }
                      }
                    },
                    onTap: () {
                      if (isSelected) {
                        if (!isCurrentSelected) {
                          Provider.of<DocumentImagesNotifier>(context, listen: false)
                              .appendSelectedIndexes(imageIndex);
                        } else {
                          Provider.of<DocumentImagesNotifier>(context, listen: false)
                              .removeAnIndexFromSelected(imageIndex);
                        }
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (buildContext) => ImagesSlider(startIndex: imageIndex,
                                    documentImages: documentImages,)));
                      }
                    },
                    child: Card(
                      shadowColor:
                         isCurrentSelected
                              ? Colors.grey[500]
                              : null,
                      elevation:
                         isCurrentSelected
                              ? 8.0
                              : 0.0,
                      child: Hero(
                          tag: '${imageDocument.imageId}',
                          child: AspectRatio(
                            aspectRatio: 1/1.5,
                            child: Image(
                                      image: FileImage(File(imageFile)),
                                      fit: BoxFit.fill,
                                    )
                          )),
                    ),
                  ),
                ),

                if (isSelected)
                  Align(
                      alignment: Alignment.topRight,
                      child: Checkbox(
                        value: isCurrentSelected ? true : false,
                        onChanged: (value) {

                          if (isCurrentSelected) {
                            Provider.of<DocumentImagesNotifier>(context, listen: false)
                                .removeAnIndexFromSelected(imageIndex);
                          } else {
                            Provider.of<DocumentImagesNotifier>(context, listen: false)
                                .appendSelectedIndexes(imageIndex);
                          }

                        },
                      )),
              ],
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Text(
              (imageIndex + 1).toString(),
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

}
