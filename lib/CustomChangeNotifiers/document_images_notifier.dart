
import 'package:flutter/cupertino.dart';
import 'package:mind_map_generator/DataModels/document_image.dart';
import 'package:mind_map_generator/LocalDatabaseService/document_database.dart';

class DocumentImagesNotifier extends ChangeNotifier{

  List<DocumentImage> documentImages = [];

  append(DocumentImage documentImage){

    documentImages.add(documentImage);
    notifyListeners();
    DocumentsDatabaseNotifier().insertDocumentImage(documentImage);
  }

  update(DocumentImage documentImage, int index){

    documentImages[index].imageFilePath = documentImage.imageFilePath;
    notifyListeners();
    DocumentsDatabaseNotifier().updateDocumentImage(documentImage);
  }

  delete(String imageId, int index){

    documentImages.removeAt(index);
    notifyListeners();
    DocumentsDatabaseNotifier().deleteDocumentImage(imageId);
  }

}