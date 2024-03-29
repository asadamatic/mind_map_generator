import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/ImageService/image_service.dart';
import 'package:mind_map_generator/ListViews/document_images_grid_screen.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';
import 'package:mind_map_generator/mind_map_generator_screen.dart';
import 'package:share/share.dart';

class DocumentImagesNotifier extends ChangeNotifier {
  List<DocumentImage> _documentImages = [];
  List<String> _documentImagePaths = [];

  List<int> _selectedDocumentImagesIndexes = [];

  List<int> get selectedDocumentImagesIndexes => _selectedDocumentImagesIndexes;

  List<DocumentImage> get documentImages => _documentImages;
  List<String> get documentImagePaths => _documentImagePaths;

  String _id;
  ImageScreenActions _imageScreenActions;
  set documentImages(List<DocumentImage> newDocumentImages) {
    _documentImages = newDocumentImages;
    notifyListeners();
  }

  set documentImagePaths(List<String> newBase64EncodedImages) {
    _documentImagePaths = newBase64EncodedImages;
    notifyListeners();
  }

  set selectedDocumentImagesIndexes(List<int> newSelectedMindMaps) {
    _selectedDocumentImagesIndexes = newSelectedMindMaps;
    notifyListeners();
  }

  DocumentImagesNotifier({String docId, ImageScreenActions imageScreenActions}) {
    loadValue(docId);
    _imageScreenActions = imageScreenActions;
    _id = docId;
  }

  Future<void> loadValue(String docId) async {
    documentImages = await DocumentsDatabaseNotifier().documentImages(docId);
    documentImagePaths = documentImages.map((e) => e.imageFilePath).toList();
  }

  append(DocumentImage documentImage) {
    if (!_documentImages.contains(documentImage)) {
      _documentImages.add(documentImage);
      _documentImagePaths.add(documentImage.imageFilePath);
    }

    notifyListeners();
    DocumentsDatabaseNotifier().insertDocumentImage(documentImage);
  }

  update(String imageFilePath) {
    _documentImages[_selectedDocumentImagesIndexes[0]].imageFilePath =
        imageFilePath;
    _documentImagePaths[_selectedDocumentImagesIndexes[0]] = imageFilePath;
    DocumentsDatabaseNotifier().updateDocumentImage(
        _documentImages[_selectedDocumentImagesIndexes[0]]);
    removeAllSelectedIndexes();
    notifyListeners();
  }

  updateDocumentStatus(String docId, int status) {
    _documentImages.forEach((documentImage) => documentImage.status = status);
    notifyListeners();
    DocumentsDatabaseNotifier().updateDocumentStatus(docId, status);
  }

  deleteAllSelected() {
    for (int index in _selectedDocumentImagesIndexes) {
      DocumentsDatabaseNotifier()
          .deleteDocumentImage(_documentImages.elementAt(index).imageId);
      _documentImages.removeAt(index);
      _documentImagePaths.removeAt(index);
    }
    removeAllSelectedIndexes();

    notifyListeners();
  }

  appendSelectedIndexes(int newSelectedIndex) {
    if (!_selectedDocumentImagesIndexes.contains(newSelectedIndex)) {
      _selectedDocumentImagesIndexes.add(newSelectedIndex);
      _selectedDocumentImagesIndexes.sort();
      _selectedDocumentImagesIndexes =
          _selectedDocumentImagesIndexes.reversed.toList();
      notifyListeners();
    }
  }

  removeAllSelectedIndexes() {
    _selectedDocumentImagesIndexes = [];
    notifyListeners();
  }

  removeAnIndexFromSelected(int removeIndex) {
    _selectedDocumentImagesIndexes.remove(removeIndex);
    notifyListeners();
  }

  shareSelected(String directoryPath) {
    List<String> shareFiles = [];
    for (int index in _selectedDocumentImagesIndexes) {
      shareFiles.add(directoryPath + _documentImages[index].imageFilePath);
    }
    Share.shareFiles(shareFiles);
  }

  getDocumentImage(BuildContext buildContext, ImageSource imageSource) async {
    final filePath = await ImageService()
        .captureImage(imageSource: imageSource, buildContext: buildContext);

    if (filePath != null) {
      Navigator.pop(buildContext);
      append(DocumentImage(
          docId: _id,
          imageFilePath: filePath,
          imageId: DateTime.now().microsecondsSinceEpoch.toString(),
          status: 0));
    }
  }

  updateDocumentImage(BuildContext buildContext,
      BuildContext bottomSheetContext, ImageSource imageSource) async {
    final filePath = await ImageService()
        .captureImage(imageSource: imageSource, buildContext: buildContext);

    if (filePath != null) {
      Navigator.pop(bottomSheetContext);
      update(filePath);
    }
  }

  Future<List<String>> getBase64EncodedList(String directoryPath) {
    return Future.wait(_documentImages.map((documentImage) async {
      final file = File(directoryPath + documentImage.imageFilePath);
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    }).toList());
  }

  proceedToGenerate(BuildContext context, String directoryPath) async {
    if (_documentImages.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'Please scan your docs first!',
        style: TextStyle(fontSize: 18.0),
      )));
    } else {
      final images = await getBase64EncodedList(directoryPath);
      if (_imageScreenActions == ImageScreenActions.fromDraft ||
          _imageScreenActions == ImageScreenActions.newDocument) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MindMapGeneratorScreen(
                      base64EncodedImages: images,
                      docId: _id,
                      mapScreenActions: MindMapGeneratorScreenActions.insert,
                    )));
      } else if (_imageScreenActions == ImageScreenActions.fromMindMap) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MindMapGeneratorScreen(
                      base64EncodedImages: images,
                      docId: _id,
                      mapScreenActions: MindMapGeneratorScreenActions.update,
                    )));
      }
    }
  }
}
