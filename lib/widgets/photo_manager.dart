import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:storepedia/model/part.dart';

import '../bloc/photo_manager_bloc/photomanager_bloc.dart';
import '../cubit/edit_item_cubit/edititem_cubit.dart';
import '../cubit/photo_upload_cubit/photoupload_cubit.dart';
import '../repository/crop_image.dart';
import '../repository/image_getter.dart';
import '../screens/camera_screen/camera_page.dart';
import 'online_pinch_zoom.dart';

class PhotoManager extends StatefulWidget {
  const PhotoManager({super.key});
  @override
  PhotoManagerState createState() => PhotoManagerState();
}

class PhotoManagerState extends State<PhotoManager> {
  @override
  void initState() {
    super.initState();
  }

  //File? _selectedFile;
  //UploadTask? _uploadTask;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 3.0,
      shadowColor: Colors.blue,
      child: BlocBuilder<PhotomanagerBloc, PhotomanagerState>(
        builder: ((context, state) {
          if (state is ImageSelectedState) {
            return DisplayOfflineImage(image: state.image);
          }

          return BlocBuilder<EditItemCubit, Part>(builder: ((context, state) {
            return state.photo != null
                ? Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      OnlinePinchZoomImage(link: state.photo),
                      Positioned(
                          bottom: 10,
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white60,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () => {
                                      if (kIsWeb)
                                        {
                                          Navigator.of(context)
                                              .pushNamed(CameraPage.routName)
                                        }
                                      else
                                        {getImage(ImageSource.camera)}
                                    },
                                    child: const Icon(
                                      Icons.photo_camera,
                                      size: 36,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white60,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () => getImage(ImageSource.gallery),
                                    child: const Icon(
                                      Icons.photo,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  )
                : SizedBox(
                    width: 300,
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            getImage(ImageSource.gallery);
                          },
                          splashColor: Colors.blue,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue)),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, color: Colors.blue, size: 64),
                                Text('Gallery',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ],
                            ),
                          ),
                        )),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (kIsWeb) {
                                Navigator.pushNamed(
                                    context, CameraPage.routName);
                              } else {
                                getImage(ImageSource.camera);
                              }
                            },
                            splashColor: Colors.white,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.blue,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_camera,
                                      color: Colors.white, size: 64),
                                  Text('Camera',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          }));
        }),
      ),
    );
  }

  // void attemptUpload({required int score}) {
  //   var val = context.read<PhotouploadCubit>();
  //   var photoManager = context.read<PhotomanagerBloc>().state;
  //   var photo;
  //   var minimumScore = 64;
  //   if (photoManager is ImageSelectedState) {
  //     photo = photoManager.image;
  //   }
  //   if (score >= minimumScore && photo != null) {
  //     val.add(UploadPhotoEvent(photo: photo));
  //   }
  // }

  void getImage(ImageSource source) async {
    ImageGetter imageGetter = ImageGetter();
    if (kIsWeb) {
      await imageGetter.getWebImage().then((value) {
        context.read<PhotomanagerBloc>().add(SelectPhotoEvent(photo: value));
      }).onError((error, stackTrace) {
        print('error loading file: ${error.toString()}');
      });
      return;
    }

    await ImageGetter.getImage(source).then((value) async {
      await CropImage.getCroppedImage(context, image: value).then((value) {
        if (value != null) {
          //this will yield PhotoSelectedState
          context
              .read<PhotomanagerBloc>()
              .add(SelectPhotoEvent(photo: File(value.path)));
        }
      });
    });
  }
}

class DisplayOfflineImage extends StatelessWidget {
  const DisplayOfflineImage({
    super.key,
    required this.image,
  });

  final dynamic image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PinchZoomImage(
            image: image is File ? Image.file(image) : Image.memory(image)),
        Positioned(
          top: 20,
          right: 20,
          child: BlocBuilder<PhotouploadCubit, PhotouploadState>(
            builder: (context, state) {
              return state is PhotouploadingState
                  ? Container()
                  : Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          context
                              .read<PhotomanagerBloc>()
                              .add(RemovePhotoEvent());
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    );
            },
          ),
        ),
        Positioned(
            top: 50,
            left: 50,
            child: BlocBuilder<PhotouploadCubit, PhotouploadState>(
              builder: (context, state) {
                if (state is PhotouploadingState) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: state.percentage == 0 ? null : state.percentage,
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                if (state is PhotouploadErrorState) {
                  return Container(
                    height: 50,
                    width: 50,
                    color: Colors.white12,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.refresh, size: 64),
                        tooltip: 'Retry upload',
                        onPressed: () => context
                            .read<PhotouploadCubit>()
                            .attemptUpload(photo: image)(image),
                      ),
                    ),
                  );
                }
                return Container();
              },
            )),
      ],
    );
  }
}
