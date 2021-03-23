
class MindMap{

  final String docId, imageFile, name;

  MindMap({this.name, this.docId, this.imageFile});

  Map<String, dynamic> toMap() => {'docId': docId, 'image': imageFile, 'name': name};
}