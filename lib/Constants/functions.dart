import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> getDocumentsPathByRelativePath(String relativePath) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return relativePath != null && relativePath.isNotEmpty
      ? directory.path + relativePath
      : null;
}
