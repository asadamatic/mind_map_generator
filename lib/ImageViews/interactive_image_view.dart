import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:provider/provider.dart';

class InteractiveImageView extends StatelessWidget {
  final DocumentImage documentImage;
  const InteractiveImageView({
    Key key,
    @required this.documentImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final File imageFile = File(Provider.of<Directory>(context).path + documentImage.imageFilePath);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: InteractiveViewer(
        scaleEnabled: true,
        child: Center(
            child: Hero(
          tag: '${documentImage.imageId}',
          child: Image(image: FileImage(imageFile))
        )),
      ),
    );
  }
}
