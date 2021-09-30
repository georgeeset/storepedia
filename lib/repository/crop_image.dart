
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CropImage{

  static Future <File?> getCroppedImage({required image})async{
     return await ImageCropper.cropImage(
            sourcePath: image.path,
            compressQuality: 80,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.white,
              toolbarTitle: 'Trim it up!',
              statusBarColor: Colors.blue,
              backgroundColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              hideBottomControls: true,
              lockAspectRatio: false
            )
        );
  }

 
}