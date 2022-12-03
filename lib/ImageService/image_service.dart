import 'dart:io';
import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  final _imagePicker = ImagePicker();
  ImageService();

  static Future<String> savePickedImageToAppFolder(File image) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    String relativePath =
        '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpeg';

    String newPath = directory.path + relativePath;

    File res = await image.copy(newPath);

    return res != null && res.existsSync() ? relativePath : null;
  }

  Future<String> captureImage(
      {ImageSource imageSource, BuildContext buildContext}) async {
    File file;

    final permission = imageSource == ImageSource.camera
        ? Permission.camera
        : Permission.storage;
    final PermissionStatus status = await permission.status;

    if (status == PermissionStatus.granted) {
      final PickedFile pickedFile =
          await _imagePicker.getImage(source: imageSource);
      if (pickedFile != null) {
        file = await cropImage(pickedFile);
        if (file != null) {
          return savePickedImageToAppFolder(file);
        } else {
          Navigator.pop(buildContext);
          return null;
        }
      } else {
        Navigator.pop(buildContext);
        return null;
      }
    } else if (status == PermissionStatus.denied ||
        status == PermissionStatus.undetermined ||
        status == PermissionStatus.restricted) {
      await permission.request();
      Navigator.of(buildContext).pop();
    } else {
      showDialog(
          context: buildContext,
          builder: (buildContext) => MessageDialog(
                message:
                    'This app requires camera & storage access to function properly',
                buttonOkText: 'Open Settings',
                buttonOkOnPressed: () => openAppSettings(),
              ));
    }

    return savePickedImageToAppFolder(file);
  }

  Future<File> cropImage(PickedFile pickedFile) async {
    final file = await ImageCropper().cropImage(
        sourcePath: File(pickedFile.path).path,
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Cropper',
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(
            aspectRatioLockEnabled: false,
            minimumAspectRatio: 1.0,
            title: 'Cropper'));

    return file;
  }
  // Future<String> getCroppedImage() async {
  //   String imagePath;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     imagePath = await EdgeDetection.detectEdge;
  //   } on PlatformException {
  //     imagePath = 'Failed to get cropped image path.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   return imagePath;
  // }

//TODO:Genius Scan SDK

  // Future<String> scanDocument() async{
  //
  //   FlutterGeniusScan.scanWithConfiguration({
  //     'source': 'camera',
  //     'multiPage': false,
  //   }).then((value){ print(value);
  //
  //   return value;
  //   });
  // }

}
