import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mind_map_generator/DataModels/mind_map.dart';
import 'package:path_provider/path_provider.dart';

class NetworkService {
  final String ipv4, port;

  NetworkService({this.ipv4, this.port});

  Future<MindMap> generateMindMap(List<String> encoded, String id) async {
    final Response response = await post(
      'http://${ipv4 ?? '192.168.43.127'}:${port ?? '8000'}/analyze',
      headers: <String, String>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'encoded_imgs': encoded}),
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/$id' + DateTime.now().toString() + '.jpeg');

    await file.writeAsBytes(base64Decode(responseJson['encoded_mind_map']));


    return MindMap(
        docId: id,
        imageFile: file.path,
        name: responseJson['name'],
        text: jsonEncode(responseJson['text']));
  }

  Future<MindMap> editMindMap(List<String> listOfData, String id) async {
    final Response response = await post(
      'http://${ipv4 ?? '192.168.43.127'}:${port ?? '8000'}/edit',
      headers: <String, String>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'mindMapData': listOfData}),
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    final directory = await getApplicationDocumentsDirectory();

    final File file = File(directory.path + '/$id' + '.jpeg');

    await file.writeAsBytes(base64Decode(responseJson['encoded_imgs']));

    return MindMap(
        docId: id,
        imageFile: file.path,
        name: responseJson['name'],
        text: jsonEncode(responseJson['text']));
  }
}
