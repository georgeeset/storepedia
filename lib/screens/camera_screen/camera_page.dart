import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:storepedia/cubit/camera_cubit/camera_cubit.dart';
import 'package:storepedia/model/camera_model.dart';
import 'package:storepedia/widgets/page_layout.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});
  static String routName = '/camera_page';

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        hasBackButton: false,
        body: BlocProvider(
          create: (context) => CameraCubit(),
          child: const SingleChildScrollView(
            child: Column(
              children: [
                CameraWidget(),
                _CameraButtons(),
              ],
            ),
          ),
        ),
        title: const Text('Camera'));
  }
}

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      child: BlocConsumer<CameraCubit, CameraModel>(
          builder: (context, camera) {
            // context.read<CameraCubit>().startup();

            if (camera.isTakingPicture) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (camera.isInitialized) {
              return CameraPreview(
                camera.cameraController!,
              );
            }

            if (camera.hasError) {
              return Center(
                child: Text(camera.cameraMessage!),
              );
            }

            return const Center(
              child: Text('Initializing Camera'),
            );
          },
          listener: (context, cameraState) {}),
    );
  }
}

class _CameraButtons extends StatelessWidget {
  const _CameraButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraModel>(builder: (context, camera) {
      return Container(
        margin: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            camera.image != null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Use'),
                    onPressed: () {
                      context
                          .read<PhotomanagerBloc>()
                          .add(SelectPhotoEvent(photo: camera.image!));
                      context.read<CameraCubit>().close();
                      Navigator.of(context).pop();
                    })
                : const SizedBox(),
            camera.cameraDescription.length > 1 && camera.image == null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Switch'),
                    onPressed: () {
                      context
                          .read<CameraCubit>()
                          .changeActiveCamera(camera.activeCamera);
                    })
                : const SizedBox(),
            camera.image != null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                    onPressed: () {
                      context.read<CameraCubit>().retakePicture();
                    })
                : const SizedBox(),
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Capture'),
                onPressed: () {
                  context.read<CameraCubit>().takePicture();
                }),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Back'),
              onPressed: () {
                context.read<CameraCubit>().close();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }
}
