import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraModel {
  int activeCamera; // index of active camera description list
  bool isTakingPicture;
  bool isRecordingVideo;
  bool isStreaming;
  dynamic image;
  XFile? video;
  bool isInitialized;
  Uint8List? imageBytes; // camera photo in bytes
  CameraController? cameraController;
  List<CameraDescription> cameraDescription = [];
  String? cameraMessage;
  bool hasError;

  CameraModel({
    this.activeCamera = 0,
    this.isTakingPicture = false,
    this.isRecordingVideo = false,
    this.isStreaming = false,
    this.image,
    this.video,
    this.imageBytes,
    this.cameraController,
    this.cameraDescription = const [],
    this.isInitialized = false,
    this.cameraMessage,
    this.hasError = false,
  });

  CameraModel copyWith({
    int? activeCamera,
    bool? isTakingPicture,
    bool? isRecordingVideo,
    bool? isStreaming,
    bool? isInitialized,
    dynamic image,
    XFile? video,
    Uint8List? imageBytes,
    CameraController? cameraController,
    List<CameraDescription>? cameraDescription,
    String? cameraMessage,
    bool? hasError,
  }) {
    return CameraModel(
      activeCamera: activeCamera ?? this.activeCamera,
      isTakingPicture: isTakingPicture ?? this.isTakingPicture,
      isRecordingVideo: isRecordingVideo ?? this.isRecordingVideo,
      isStreaming: isStreaming ?? this.isStreaming,
      isInitialized: isInitialized ?? this.isInitialized,
      image: image ?? this.image,
      video: video ?? this.video,
      imageBytes: imageBytes ?? this.imageBytes,
      cameraController: cameraController ?? this.cameraController,
      cameraDescription: cameraDescription ?? this.cameraDescription,
      cameraMessage: cameraMessage ?? this.cameraMessage,
      hasError: hasError ?? false,
    );
  }

  int get getActiveCamera => activeCamera;
  bool get getIsTakingPicture => isTakingPicture;
  bool get getIsRecordingVideo => isRecordingVideo;
  bool get getIsStreaming => isStreaming;
  bool get getIsInitialized => isInitialized;
  String? get getCameraMessage => cameraMessage;
  bool get getHasError => hasError;
  dynamic get getImage => image;
  XFile? get getVideo => video;
  Uint8List? get getImageBytes => imageBytes;
  CameraController? get getCameraController => cameraController;
  List<CameraDescription> get getCameraDescription => cameraDescription;

  CameraModel removeImage() {
    return CameraModel(isInitialized: isInitialized);
  }
}
