import 'dart:convert';
import 'dart:io';
import 'package:dialogs/MessageDialog/message_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  final _imagePicker = ImagePicker();
  ImageService();

  Future<File> captureDocument(
      {ImageSource imageSource, BuildContext buildContext}) async {
    File file;

    final permission = imageSource == ImageSource.camera
        ? Permission.camera
        : Permission.storage;
    final PermissionStatus status = await permission.status;

    if (status == PermissionStatus.granted) {
      final PickedFile pickedFile =
          await _imagePicker.getImage(source: imageSource);
      // final Uint8List bytes = await pickedFile.readAsBytes();
      if (pickedFile != null) {
        file = File(pickedFile.path);

        if (file != null) {
          return file;
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
    return file;
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
      // final Uint8List bytes = await pickedFile.readAsBytes();
      if (pickedFile != null) {
        file = File(pickedFile.path);
        if (file != null) {

          return file.path;
          // final bytes = await file.readAsBytes();
          // final base64encodedImage = base64Encode(bytes);
          // return base64encodedImage;
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


    //  final bytes = await file.readAsBytes();
    // final base64encodedImage = base64Encode(bytes);
    return file.path;
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
