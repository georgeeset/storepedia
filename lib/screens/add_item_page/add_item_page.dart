import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:store_pedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';
import 'package:store_pedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:store_pedia/cubit/connectivity_cubit/cubit/connectivity_cubit.dart';
import 'package:store_pedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:store_pedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:store_pedia/cubit/photo_upload_cubit/photoupload_cubit.dart';
import 'package:store_pedia/cubit/repitition_cubit/cubit/repitition_cubit.dart';
import 'package:store_pedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/crop_image.dart';
import 'package:store_pedia/repository/image_getter.dart';
import 'package:store_pedia/screens/search_page/search_page.dart';
import 'package:store_pedia/widgets/input_editor.dart';
import 'package:store_pedia/widgets/loading_indicator.dart';
import 'package:store_pedia/widgets/online_pinch_zoom.dart';
import 'package:store_pedia/widgets/page_layout.dart';
import '../../constants/number_constants.dart' as NumberConstants;
import '../../constants/string_constants.dart' as StringConstants;

class AddItemPage extends StatelessWidget {
  const AddItemPage({Key? key}) : super(key: key);
  static String routName = '/add_item_page';

  @override
  Widget build(BuildContext context) {
    final Size sizeData = MediaQuery.of(context).size;
    return PageLayout(
      title: Text(
        'Add/Edit Store Item',
        style: Theme.of(context)
            .textTheme
            .headline6
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
              print(scoreState);
              if (state is ImageSelectedState &&
                  scoreState >= NumberConstants.minimumScore) {
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
                  SnackBar(
                    backgroundColor: Colors.blue,
                    duration:
                        Duration(seconds: NumberConstants.errorSnackBarDelay),
                    content: Text('Picture Upload Successful !'),
                  ),
                );
              }
              if (state is PhotouploadErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.pink,
                    duration:
                        Duration(seconds: NumberConstants.errorSnackBarDelay),
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
                  duration:
                      Duration(seconds: NumberConstants.errorSnackBarDelay),
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
            if (state >= NumberConstants.minimumScore &&
                photoState is ImageSelectedState) {
              upload.attemptUpload(
                photo: photoState.image,
                fileName: formStatus.photo,
              );
            }

            if (state >= NumberConstants.minimumScore) {
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
                  info: StringConstants.partNameInfo,
                  title: StringConstants.partNameTitle,
                  fieldValue: state.partName,
                  onSubmit: (value) {
                    context.read<EditItemCubit>().editPartName(value);
                  },
                ),
                FormListItem(
                  title: StringConstants.partDescriptionTitle,
                  info: StringConstants.partDescriptionInfo,
                  sizeData: sizeData,
                  fieldValue: state.partDescription,
                  onSubmit: (value) {
                    context.read<EditItemCubit>().editPartDescription(value);
                  },
                ),
                FormListItem(
                  title: StringConstants.brandTitle,
                  info: StringConstants.brandInfo,
                  sizeData: sizeData,
                  fieldValue: state.brand,
                  onSubmit: (value) {
                    context.read<EditItemCubit>().editBrand(value);
                  },
                ),
                FormListItem(
                  title: StringConstants.partNumberTitle,
                  info: StringConstants.partNumberInfo,
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
                  title: StringConstants.storeIdTitle,
                  info: StringConstants.storeIdInfo,
                  sizeData: sizeData,
                  textCapitalization: TextCapitalization.characters,
                  fieldValue: state.storeId,
                  onSubmit: (value) {
                    context.read<EditItemCubit>().editStoreid(value);
                  },
                ),
                FormListItem(
                  title: StringConstants.storeLocationTitle,
                  info: StringConstants.storeLocationInfo,
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
                PhotoManager(),

                //checking for duplicate part.
                // if duplicate is found, then
                // Upload part button will not be activated
                Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
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
                                .subtitle1!
                                .copyWith(
                                    color: Colors.redAccent,
                                    decoration: TextDecoration.underline),
                          ),
                        );
                      } else {
                        if (repititionState is RepititionSearchError) {
                          return Icon(Icons.running_with_errors);
                        } else {
                          return Container();
                        }
                      }
                    }),
                  ),
                ),
                Container(
                  //height: 100.0,
                  padding: EdgeInsets.all(10),
                  child:
                      BlocBuilder<PartuploadwizardBloc, PartuploadwizardState>(
                    builder: (context, uploadState) {
                      return uploadState is PartuploadwizardLoadingState
                          ? Center(child: LoadingIndicator())
                          : ElevatedButton(
                              onPressed: () {
                                var score =
                                    context.read<FormLevelCubit>().state;
                                var userInfo =
                                    context.read<UserManagerCubit>().state;
                                var network =
                                    context.read<ConnectivityCubit>().state;
                                if (userInfo is UserLoadedState) {
                                  context
                                      .read<EditItemCubit>()
                                      .updateTheRestInfo(userInfo.userData);
                                }

                                if (network is ConnectivityOffline) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.pink,
                                      duration: Duration(
                                          seconds: NumberConstants
                                              .errorSnackBarDelay),
                                      content: Text('Your Device is Offline!'),
                                    ),
                                  );
                                } else {
                                  Future.delayed(
                                      Duration(seconds: 1),
                                      () => context
                                          .read<PartuploadwizardBloc>()
                                          .add(UploadPartEvent(
                                              part: context
                                                  .read<EditItemCubit>()
                                                  .state,
                                              score: score)));
                                }
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
        return Container(
          width: sizeData.width / 1.1,
          height: 5,
          child: LinearProgressIndicator(
            valueColor: state >= NumberConstants.minimumScore
                ? AlwaysStoppedAnimation<Color>(Colors.purple)
                : AlwaysStoppedAnimation<Color>(Colors.red),
            value: state / 100,
          ),
        );
      }),
    );
  }
}

class PhotoManager extends StatefulWidget {
  const PhotoManager({Key? key}) : super(key: key);

  @override
  _PhotoManagerState createState() => _PhotoManagerState();
}

class _PhotoManagerState extends State<PhotoManager> {
  @override
  void initState() {
    super.initState();
  }

  //File? _selectedFile;
  //UploadTask? _uploadTask;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 3.0,
      shadowColor: Colors.blue,
      child: BlocBuilder<PhotomanagerBloc, PhotomanagerState>(
        builder: ((context, state) {
          if (state is ImageSelectedState) {
            return DisplayOfflineImage(image: state.image);
          }

          // if (state is ImageUploadingState) {
          //   //indicate uploading with uploading widget
          //   return StreamBuilder<TaskSnapshot>(
          //       stream: state.uploadInfo,
          //       builder: (context, snapshot) {
          //         var value= (snapshot.data!.totalBytes -
          //                             snapshot.data!.bytesTransferred) *
          //                         (100 / snapshot.data!.totalBytes);
          //         return snapshot.hasData
          //             ? Container(
          //                 width: 60,
          //                 height: 60,
          //                 child: CircularProgressIndicator(
          //                     value: value),)
          //             : Container();
          //       });
          // }

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
                          child: Container(
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
                                    child: Icon(
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
                                    child: Icon(
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
                : Container(
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
                            child: Column(
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
                              child: Column(
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
    await ImageGetter.getImage(source).then((value) async {
      if (value != null) {
        await CropImage.getCroppedImage(image: value).then((value) {
          if (value != null) {
            //this will yield PhotoSelectedState
            context
                .read<PhotomanagerBloc>()
                .add(SelectPhotoEvent(photo: value));
          }
        });
      }
    });
  }
}

class DisplayOfflineImage extends StatelessWidget {
  const DisplayOfflineImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  final File image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PinchZoomImage(image: Image.file(image)),
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
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          context
                              .read<PhotomanagerBloc>()
                              .add(RemovePhotoEvent());
                        },
                        child: Icon(
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
                  return Container(
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
                        icon: Icon(Icons.refresh, size: 64),
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
    Key? key,
    required this.onSelect,
    this.fieldValue,
  }) : super(key: key);
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
      margin: EdgeInsets.all(10),
      shadowColor: Colors.blue,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringConstants.isMachineSpecific,
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
            ),
            DropdownButton(
              isExpanded: true,
              value: fieldValue, //changed when tapped
              elevation: 3,
              hint: Text(
                'Select Department',
              ),
              items: machineList.map((String machine) {
                return DropdownMenuItem<String>(
                  child: Text(
                    machine,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  value: machine,
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

class FormListItem extends StatelessWidget {
  const FormListItem({
    Key? key,
    required this.sizeData,
    this.fieldValue,
    required this.title,
    required this.info,
    required this.onSubmit,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputType,
    this.initialValue,
    this.noSpace = false,
  }) : super(key: key);

  final Size sizeData;
  final String title;
  final String info;
  final String? fieldValue;
  final Function onSubmit;
  final TextInputType? textInputType;
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final bool noSpace;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 3.0,
      shadowColor: Colors.blue,
      child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    //width: sizeData.width / 2,
                    child: Text(
                      info,
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.black54),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Divider(),
              InkWell(
                onTap: () {
                  SignupFormDialog.formDialog(
                    context: context,
                    onSubmit: onSubmit,
                    title: title,
                    initialValue: fieldValue,
                    textCapitalization: textCapitalization,
                    noSpace: noSpace,
                  );
                },
                child: Container(
                  color: Colors.red[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          fieldValue ?? '<Empty>',
                          softWrap: true,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
