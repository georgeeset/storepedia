import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageGetter {
  ImageGetter();

  static Future<File> getImage(ImageSource source) async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source, imageQuality: 30);
    if (image != null) {
      return File(image.path);
      //image.delete(recursive: false);
    }
    return Future.error('No image');
    // print('no Image');
  }

  static Future<File> getSelfie() async {
    final PickedFile? selfie = await ImagePicker().getImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (selfie != null) {
      return File(selfie.path);
      //image.delete(recursive: false);
    }
    return Future.error('no selfie');
    //print('no selfie');
  }

  static Future<File> getVideo(ImageSource source) async {
    final PickedFile? video = await ImagePicker().getVideo(
      source: source,
      maxDuration: Duration(minutes: 5),
    );
    if (video != null) {
      return File(video.path);
      //image.delete(recursive: false);
    }
    return Future.error('no Video');
    //print('no video');
  }
}
