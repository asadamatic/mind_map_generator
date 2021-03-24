import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class NetworkService {
  final String ipv4, port;

  NetworkService({this.ipv4, this.port});

  Future<String> connectToServer(List<String> encoded, String id) async {

    final Response response = await post(
      'http://${ipv4 ?? '192.168.43.127'}: ${port ?? '8000'}/analyze',
      headers: <String, String>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'encoded_img': encoded}),
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    final directory = await getApplicationDocumentsDirectory();
    final File file = File(directory.path + '/id' + '.jpeg');
    await file.writeAsBytes(base64Decode(responseJson['encoded_img']));
    return file.path;
  }
}
