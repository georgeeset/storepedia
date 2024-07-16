import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/cubit/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/widgets/form_list_item.dart';
import 'package:storepedia/widgets/page_layout.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:storepedia/constants/string_constants.dart' as string_constants;

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});
  static const String routeName = '/profile_edit_page';
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final userData = arguments['user_data'];

    return PageLayout(
        body: ProfileEditForm(
          user: userData,
        ),
        title: const Text("Profile"));
  }
}

class ProfileEditForm extends StatelessWidget {
  final UserModel user;

  const ProfileEditForm({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final Size sizeData = MediaQuery.of(context).size;
    // context.read<EditProfileCubit>().updateUser(user);
    return BlocBuilder<EditProfileCubit, UserModel>(
      builder: (context, state) => Column(
        children: [
          CircleAvatar(
            backgroundImage: user.profilePhoto != null
                ? NetworkImage(user.profilePhoto!)
                : null,
            child: user.profilePhoto == null ? const Icon(Icons.person) : null,
          ),
          ElevatedButton(
            onPressed: () {
              Future<void> showImagePickerDialog(BuildContext context) async {
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: Platform.isAndroid
                      ? ImageSource.gallery
                      : ImageSource.gallery,
                );

                if (pickedFile != null) {
                  // Handle the picked image file
                }
              }
            },
            child: const Text('Select Profile Picture'),
          ),
          FormListItem(
            sizeData: sizeData,
            title: string_constants.fullName,
            initialValue: state.userName,
            info: 'This Can not be changed',
            onSubmit: (value) {
              context.read<EditProfileCubit>().editFullName(value);
            },
          ),
          FormListItem(
            sizeData: sizeData,
            title: string_constants.company,
            initialValue: state.company,
            info:
                'Update Your Company Name, ask your coliques if they already have one created, so you can join them',
            onSubmit: (value) {
              context.read<EditProfileCubit>().editCompanyName(value);
            },
          ),
          FormListItem(
            sizeData: sizeData,
            title: string_constants.branch,
            initialValue: state.branch,
            info: 'State your company branch or location',
            onSubmit: (value) {
              context.read<EditProfileCubit>().editBranch(value);
            },
          ),
        ],
      ),
    );
  }
}
