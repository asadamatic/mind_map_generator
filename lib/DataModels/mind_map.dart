
class MindMap{

  String docId, imageFile, name, text;

  MindMap({this.name, this.docId, this.imageFile, this.text});

  Map<String, dynamic> toMap() => {'docId': docId, 'image': imageFile, 'name': name, 'text': text};
}