import 'dart:convert';

import 'package:http/http.dart';

class NetworkService {
  final String ipv4, port;

  NetworkService({this.ipv4, this.port});

  Future<String> connectToServer(List<String> encoded) async {

    final Response response = await post(
      'http://${ipv4 ?? '192.168.43.127'}: ${port ?? '8000'}/analyze',
      headers: <String, String>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'encoded_img': encoded}),
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);



    return responseJson['encoded_img'].toString();
  }
}
