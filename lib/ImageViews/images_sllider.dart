import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/on_boarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ImagesSlider extends StatefulWidget {
  List<DocumentImage> documentImages;
  final int startIndex;
  ImagesSlider({this.documentImages, this.startIndex});
  @override
  _ImagesSliderState createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  int currentPage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPage = widget.startIndex;
    controller = PageController(initialPage: widget.startIndex);
  }

  PageController controller;
  @override
  Widget build(BuildContext context) {
    final imageFile = File(Provider.of<Directory>(context).path +
        widget.documentImages[currentPage].imageFilePath);
    final directoryPath = Provider.of<Directory>(context).path;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.shareFiles(['$imageFile'], text: '');
              }),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                child: PageView.builder(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemCount: widget.documentImages?.length ?? 0,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      final File imageFile = File(directoryPath +
                          widget.documentImages[itemIndex].imageFilePath);
                      return Image(
                        height: MediaQuery.of(context).size.height * .7,
                        width: MediaQuery.of(context).size.width * .9,
                        image: FileImage(imageFile),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.documentImages.map(
                    (e) {
                      final index = widget.documentImages.indexOf(e);
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Indicator(
                          positionIndex: index,
                          currentPage: currentPage,
                        ),
                      );
                    },
                  ).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
