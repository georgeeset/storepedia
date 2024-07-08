import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

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

  Future<Uint8List> getWebImage() async {
    /// get image with imagepicker web for web palatform
    final fromPicker = await ImagePickerWeb.getImageAsBytes();
    if (fromPicker != null) {
      return fromPicker;
    }
    return Future.error('No Image');
  }

  static Future<File> getSelfie() async {
    final XFile? selfie = await ImagePicker().pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (selfie != null) {
      return File(selfie.path);
      //image.delete(recursive: false);
    }
    return Future.error('no selfie');
    //print('no selfie');
  }

  static Future<File> getVideo(ImageSource source) async {
    final XFile? video = await ImagePicker().pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 5),
    );
    if (video != null) {
      return File(video.path);
      //image.delete(recursive: false);
    }
    return Future.error('no Video');
    //print('no video');
  }
}
