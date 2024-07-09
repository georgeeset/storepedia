import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:storepedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';
import 'package:storepedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:storepedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:storepedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:storepedia/cubit/photo_upload_cubit/photoupload_cubit.dart';
import 'package:storepedia/cubit/repitition_cubit/cubit/repitition_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/crop_image.dart';
import 'package:storepedia/repository/image_getter.dart';
import 'package:storepedia/screens/search_page/search_page.dart';
import 'package:storepedia/widgets/form_list_item.dart';
import 'package:storepedia/widgets/loading_indicator.dart';
import 'package:storepedia/widgets/online_pinch_zoom.dart';
import 'package:storepedia/widgets/page_layout.dart';
import '../../constants/number_constants.dart' as number_constants;
import '../../constants/string_constants.dart' as string_constants;

class AddItemPage extends StatelessWidget {
  const AddItemPage({super.key});
  static String routName = '/add_item_page';

  @override
  Widget build(BuildContext context) {
    final Size sizeData = MediaQuery.of(context).size;
    return PageLayout(
      title: Text(
        'Add/Edit Store Item',
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.white),
      ),
      hasBackButton: true,
      body: MultiBlocListener(
        listeners: [
          ///When Image is selected by PhotoManagerBloc:
          ///Check if the part editor form has passed the minimum form score
          ///Then start uploading the Image rightaway
          BlocListener<PhotomanagerBloc, PhotomanagerState>(
            listener: (context, state) {
              var scoreState = context.read<FormLevelCubit>().state;
              // print(scoreState);
              if (state is ImageSelectedState &&
                  scoreState >= number_constants.minimumScore) {
                context
                    .read<PhotouploadCubit>()
                    .attemptUpload(photo: state.image);
              }

              if (state is PhotomanagerEmptyState) {
                var itemEditor = context.read<EditItemCubit>();
                var photoUpload = context.read<PhotouploadCubit>().state;
                var userInfo = context.read<UserManagerCubit>().state;

                if (photoUpload is PhotouploadedState) {
                  itemEditor.editPhoto(photoUpload.uploadLink);
                }
                if (userInfo is UserLoadedState) {
                  itemEditor.updateTheRestInfo(userInfo.userData);
                }
              }
            },
          ),

          ///when photo is uploaded:
          ///Update the link of uploaded file to the part Being Edited
          ///Indicate That the file have been uploaded Ok
          ///Add search Keywords to part
          BlocListener<PhotouploadCubit, PhotouploadState>(
            listener: (context, state) {
              if (state is PhotouploadedState) {
                //Ensure photo is removed to prevent image form uploading again
                context.read<PhotomanagerBloc>().add(RemovePhotoEvent());

                // itemEditor.editPhoto(state.uploadLink);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.blue,
                    duration:
                        Duration(seconds: number_constants.errorSnackBarDelay),
                    content: Text('Picture Upload Successful !'),
                  ),
                );
              }
              if (state is PhotouploadErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.pink,
                    duration: const Duration(
                        seconds: number_constants.errorSnackBarDelay),
                    content: Text('Picture Upload Failed ${state.message}'),
                  ),
                );
              }
            },
          ),

          BlocListener<PartuploadwizardBloc, PartuploadwizardState>(
              listener: (context, state) {
            /// display information if upload is successful
            if (state is PartuploadwizardErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.pink,
                  duration: const Duration(
                      seconds: number_constants.errorSnackBarDelay),
                  content: Text('Upload failed ${state.message}'),
                ),
              );
            }

            /// clear from make them no send am again
            if (state is PartuploadwizardLoadedState) {
              context.read<EditItemCubit>().clearPart();
              context.read<PhotomanagerBloc>().add(RemovePhotoEvent());
            }
          }),

          ///listen for form level to help activate file upload if file has been uploaded
          ///check if:
          ///Image have been selected,
          ///AND Image have NOT been uploaded
          ///AND Form score have passed minimum setpoint
          ///Do Upload the Image
          BlocListener<FormLevelCubit, int>(listener: (context, state) {
            var photoState = context.read<PhotomanagerBloc>().state;
            var upload = context.read<PhotouploadCubit>();
            var formStatus = context.read<EditItemCubit>().state;
            if (state >= number_constants.minimumScore &&
                photoState is ImageSelectedState) {
              upload.attemptUpload(
                photo: photoState.image,
                fileName: formStatus.photo,
              );
            }

            if (state >= number_constants.minimumScore) {
              var formStatus = context.read<EditItemCubit>().state;
              context.read<RepititionCubit>().searchDB(
                    partNumber: formStatus.partNumber,
                    storeid: formStatus.storeId,
                    storageLocation: formStatus.storeLocation,
                  );
            }
          }),

          // BlocListener<RepititionCubit, RepititionCubitState>(
          //   listener: (context,repititionState){
          //     if(repititionState is RepititionNotFoundState){
          //       //upload file if you like
          //     }
          // }),
        ],
        child: BlocBuilder<EditItemCubit, Part>(
          builder: (context, state) {
            // print(state.partUid);
            return ListView(
              children: [
                FormListItem(
                  sizeData: sizeData,
                  info: string_constants.partNameInfo,
                  title: string_constants.partNameTitle,
                  fieldValue: state.partName,
                  onSubmit: (value) {
                    context.read<EditItemCubit>().editPartName(value);
                  },
                ),
                FormListItem(
                  title: string_constants.partDescriptionTitle,
                  info: string_constants.partDescriptionInfo,
                  sizeData: sizeData,
                  fieldValue: state.partDescription,
                  onSubmit: (value) {
                    context.read<EditItemCubit>().editPartDescription(value);
                  },
                ),
                FormListItem(
                  title: string_constants.brandTitle,
                  info: string_constants.brandInfo,
                  sizeData: sizeData,
                  fieldValue: state.brand,
                  onSubmit: (value) {
                    context.read<EditItemCubit>().editBrand(value);
                  },
                ),
                FormListItem(
                  title: string_constants.partNumberTitle,
                  info: string_constants.partNumberInfo,
                  sizeData: sizeData,
                  fieldValue: state.partNumber,
                  textCapitalization: TextCapitalization.characters,
                  onSubmit: (value) {
                    value = value.replaceAll(' ', '');
                    value = value.toUpperCase();
                    context.read<EditItemCubit>().editPartNumber(value);
                  },
                ),
                FormListItem(
                  title: string_constants.storeIdTitle,
                  info: string_constants.storeIdInfo,
                  sizeData: sizeData,
                  textCapitalization: TextCapitalization.characters,
                  fieldValue: state.storeId,
                  onSubmit: (value) {
                    context.read<EditItemCubit>().editStoreid(value);
                  },
                ),
                FormListItem(
                  title: string_constants.storeLocationTitle,
                  info: string_constants.storeLocationInfo,
                  sizeData: sizeData,
                  fieldValue: state.storeLocation,
                  textCapitalization: TextCapitalization.characters,
                  noSpace: true,
                  onSubmit: (value) {
                    context.read<EditItemCubit>().editStoreLocation(value);
                  },
                ),
                SectionDropdown(
                  onSelect: (value) {
                    context.read<EditItemCubit>().editSection(value);
                  },
                  fieldValue: state.section,
                ),
                const PhotoManager(),

                //checking for duplicate part.
                // if duplicate is found, then
                // Upload part button will not be activated
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: BlocBuilder<RepititionCubit, RepititionCubitState>(
                        builder: (context, repititionState) {
                      if (repititionState is RepititionFoundState &&
                          state.partUid == null) {
                        return TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SearchPage.routName);
                          },
                          child: Text(
                            'It seems the part already exist,\n Click Here to View,Edit or Delete the existing part.',
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.redAccent,
                                    decoration: TextDecoration.underline),
                          ),
                        );
                      } else {
                        if (repititionState is RepititionSearchError) {
                          return const Icon(Icons.running_with_errors);
                        } else {
                          return Container();
                        }
                      }
                    }),
                  ),
                ),
                Container(
                  //height: 100.0,
                  padding: const EdgeInsets.all(10),
                  child:
                      BlocBuilder<PartuploadwizardBloc, PartuploadwizardState>(
                    builder: (context, uploadState) {
                      return uploadState is PartuploadwizardLoadingState
                          ? const Center(child: LoadingIndicator())
                          : ElevatedButton(
                              onPressed: () {
                                var score =
                                    context.read<FormLevelCubit>().state;
                                var userInfo =
                                    context.read<UserManagerCubit>().state;
                                if (userInfo is UserLoadedState) {
                                  context
                                      .read<EditItemCubit>()
                                      .updateTheRestInfo(userInfo.userData);
                                }

                                Future.delayed(
                                    const Duration(seconds: 1),
                                    () => context
                                        .read<PartuploadwizardBloc>()
                                        .add(UploadPartEvent(
                                            part: context
                                                .read<EditItemCubit>()
                                                .state,
                                            score: score)));
                              },
                              child: Text(state.partUid == null
                                  ? 'Add Part'
                                  : 'Update'),
                            );
                    },
                  ),
                ),
                Container(
                  height: 45,
                ),
              ],
            );
          },
        ),
      ),
      levelIndicator:
          BlocBuilder<FormLevelCubit, int>(builder: (context, state) {
        return SizedBox(
          width: sizeData.width / 1.1,
          height: 5,
          child: LinearProgressIndicator(
            valueColor: state >= number_constants.minimumScore
                ? const AlwaysStoppedAnimation<Color>(Colors.purple)
                : const AlwaysStoppedAnimation<Color>(Colors.red),
            value: state / 100,
          ),
        );
      }),
    );
  }
}

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
            // if (kIsWeb) {
            //   return OfflineWebImage(image: state.image);
            // }
            return DisplayOfflineImage(image: state.image);
          }

          return BlocBuilder<EditItemCubit, Part>(builder: ((context, state) {
            return state.photo != null
                ? Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // CachedNetworkImage(
                      //   imageUrl: state.photo!,
                      //   errorWidget: (context,_,__)=>Image.asset('assets/images/main_logo.jpg'),
                      //   placeholder:(context,_)=> Center(child: LoadingIndicator()),

                      // ),
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
                                    onTap: () => getImage(ImageSource.camera),
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
                              getImage(ImageSource.camera);
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

  getImage(ImageSource source) async {
    ImageGetter imageGetter = ImageGetter();
    if (kIsWeb) {
      await imageGetter.getWebImage().then((value) {
        context.read<PhotomanagerBloc>().add(SelectPhotoEvent(photo: value));
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

class OfflineWebImage extends StatelessWidget {
  const OfflineWebImage({required this.image, super.key});
  final Uint8List image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.memory(image),
    );
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

class SectionDropdown extends StatelessWidget {
  const SectionDropdown({
    super.key,
    required this.onSelect,
    this.fieldValue,
  });
  final String? fieldValue;
  final Function onSelect;
  @override
  Widget build(BuildContext context) {
    List<String> machineList = [
      'Electrical',
      'Mechanical',
      'Utility',
      'Quality',
      'Production',
    ];

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.all(10),
      shadowColor: Colors.blue,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              string_constants.isMachineSpecific,
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
            ),
            DropdownButton(
              isExpanded: true,
              value: fieldValue, //changed when tapped
              elevation: 3,
              hint: const Text(
                'Select Department',
              ),
              items: machineList.map((String machine) {
                return DropdownMenuItem<String>(
                  value: machine,
                  child: Text(
                    machine,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }).toList(),

              onChanged: (newValue) {
                onSelect(newValue);
              }, //changes is done here
            ),
          ],
        ),
      ),
    );
  }
}
