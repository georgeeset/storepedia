import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_pedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';
import 'package:store_pedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:store_pedia/bloc/photo_upload_bloc.dart/cubit/photoupload_cubit.dart';
import 'package:store_pedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:store_pedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:store_pedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/crop_image.dart';
import 'package:store_pedia/repository/image_getter.dart';
import 'package:store_pedia/widgets/input_editor.dart';
import 'package:store_pedia/widgets/loading_indicator.dart';
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
      body: BlocBuilder<EditItemCubit, Part>(
        builder: (context, state) {
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
                onSubmit: (value) {
                  context.read<EditItemCubit>().editPartNumber(value);
                },
              ),
              FormListItem(
                title: StringConstants.storeIdTitle,
                info: StringConstants.storeIdInfo,
                sizeData: sizeData,
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
              Card(
                margin: EdgeInsets.all(10.0),
                elevation: 3.0,
                shadowColor: Colors.blue,
                child: Container(
                  height: 50.0,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<PartuploadwizardBloc,
                            PartuploadwizardState>(
                          builder: (context, uploadState) {
                            return uploadState is PartuploadwizardLoadingState
                                ? Center(child: LoadingIndicator())
                                : ElevatedButton(
                                    onPressed: () {
                                      var score =
                                          context.read<FormLevelCubit>().state;
                                      context.read<PartuploadwizardBloc>().add(
                                          UploadPartEvent(
                                              part: state, score: score));
                                    },
                                    child: Text('Add Part'),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
      child: BlocConsumer<PhotomanagerBloc, PhotomanagerState>(
        listener: (context, state){
          var scoreState=context.read<FormLevelCubit>().state;
          print(scoreState);
          if(state is ImageSelectedState && scoreState>NumberConstants.minimumScore){
            context.read<PhotouploadCubit>().attemptUpload(photo: state.image);
          }
        },
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
                      CachedNetworkImage(
                        imageUrl: state.photo!,
                      ),
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
            context.read<PhotomanagerBloc>()
              ..add(SelectPhotoEvent(photo: value));
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
        Image.file(image),
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
                          )),
                    );
            },
          ),
        ),
        Positioned(
            top: 50,
            left: 50,
            child: BlocConsumer<PhotouploadCubit, PhotouploadState>(
              listener: (context, state) {
                if (state is PhotouploadedState) {
                  var itemEditor= context.read<EditItemCubit>();
                  var userInfo=context.read<UserManagerCubit>().state;
                  itemEditor.editPhoto(state.uploadLink);
                  if(userInfo is UserLoadedState){
                    itemEditor.updateTheRestInfo(userInfo.userData);
                  }
                  

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
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.refresh, size: 64),
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
    this.textCapitalization,
    this.textInputType,
    this.initialValue,
  }) : super(key: key);

  final Size sizeData;
  final String title;
  final String info;
  final String? fieldValue;
  final Function onSubmit;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final String? initialValue;

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
                      initialValue: fieldValue);
                },
                child: Container(
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
