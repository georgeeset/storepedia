import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/model/camera_model.dart';

class CameraCubit extends Cubit<CameraModel> {
  late CameraModel camera;

  late CameraDescription cameraDescription;
  late CameraController cameraController;
  late List<CameraDescription> cameras = [];

  CameraCubit() : super(CameraModel()) {
    print('camera cubit build');
    startup();
  }

  void startup() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    cameraController.initialize().then((_) {
      emit(state.copyWith(
        activeCamera: 0,
        isInitialized: true,
        cameraController: cameraController,
        cameraDescription: cameras,
      ));
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            emit(state.copyWith(
                hasError: true, cameraMessage: 'Camera Access Denied'));
            break;
          default:
            emit(state.copyWith(
                hasError: true, cameraMessage: 'Camera Error: $e'));
            break;
        }
      }
    });
    print('initing');
  }

  void changeActiveCamera(int index) {
    var newIndex = index += 1;
    if (newIndex >= state.cameraDescription.length) newIndex = 0;

    var controller = CameraController(
        state.cameraDescription[newIndex], ResolutionPreset.max);

    emit(camera.copyWith(activeCamera: newIndex, cameraController: controller));
  }

  void takePicture() async {
    emit(state.copyWith(isTakingPicture: true));

    var picture = await cameraController.takePicture();

    emit(state.copyWith(
        isTakingPicture: false, image: await picture.readAsBytes()));
  }

  void takeVideo() {
    camera.isRecordingVideo = true;
    emit(state.copyWith(isRecordingVideo: true));
  }

  void stopVideo() {
    camera.isRecordingVideo = false;
    emit(state.copyWith(isRecordingVideo: false));
  }

  void retakePicture() async {
    await cameraController.pausePreview();
    emit(state.copyWith(image: null));
    await cameraController.resumePreview();
  }

  void stopPicture() {
    camera.isTakingPicture = false;
    emit(state.copyWith(isTakingPicture: false));
  }

  void streamCamera() {
    camera.isStreaming = true;
    emit(state.copyWith(isStreaming: true));
  }

  void stopStream() {
    camera.isStreaming = false;
    emit(state.copyWith(isStreaming: false));
  }

  void setImage(String image) {
    camera.image = image;
    emit(state.copyWith(image: image));
  }

  void setVideo(XFile video) {
    camera.video = video;
    emit(state.copyWith(video: video));
  }

  void setImageBytes(Uint8List imageBytes) {
    camera.imageBytes = imageBytes;
    emit(state.copyWith(imageBytes: imageBytes));
  }

  void setCameraController(CameraController cameraController) {
    camera.cameraController = cameraController;
    emit(state.copyWith(cameraController: cameraController));
  }

  void setCameraDescription(List<CameraDescription> cameraDescription) {
    camera.cameraDescription = cameraDescription;
    emit(state.copyWith(cameraDescription: cameraDescription));
  }

  @override
  void onChange(Change<CameraModel> change) {
    // TODO: implement onChange
    print('camera cubit change');
    super.onChange(change);
  }

  @override
  Future<void> close() async {
    await cameraController.dispose();
    state.cameraController?.dispose();
    return super.close();
  }
}
