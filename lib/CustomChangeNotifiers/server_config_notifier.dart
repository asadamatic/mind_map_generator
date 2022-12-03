import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerConfigNotifier extends ChangeNotifier {
  String host , port;

  ServerConfigNotifier() {
    loadValue();
  }

  Future<void> loadValue() async {
    host = await getServerConfig('host');

    port = await getServerConfig('port');
  }

  Future<String> getServerConfig(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  setServerConfigValues(String newHost, String newPort) async{
    host = newHost;
    await storeServerConfigValues('host', newHost);
    port = newPort;

    await storeServerConfigValues('port', newPort);
    notifyListeners();
  }

  Future<void> storeServerConfigValues(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}
