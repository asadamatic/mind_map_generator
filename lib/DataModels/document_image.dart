
class DocumentImage{
  String docId, imageFilePath, imageId;
  int status;

  DocumentImage({this.docId, this.imageFilePath, this.imageId, this.status});

  Map<String, dynamic> toMap(){

    return {
      'docId': docId,
      'image': imageFilePath,
      'imageId': imageId,
      'status': status
    };
  }

}