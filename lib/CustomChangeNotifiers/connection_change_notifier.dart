import 'package:flutter/cupertino.dart';

class ConnectionChangeNotifier extends ChangeNotifier {
  String _ipv4 = '127.0.0.1', _port = '8000';

  change(ipv4, port) {
    _ipv4 = ipv4;
    _port = port;

    notifyListeners();
  }

  String get ipv4 => _ipv4;
  String get port => _port;


}
