import 'package:flutter/material.dart';
import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/widgets/page_layout.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});
  static String routName = '/profile_edit_page';
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
    return Form(
      child: Column(
        children: [
          TextFormField(
            initialValue: user.company,
            decoration: const InputDecoration(
              labelText: 'Company Name',
            ),
          ),
          TextFormField(
            initialValue: user.branch,
            decoration: const InputDecoration(
              labelText: 'Branch',
            ),
          ),
          CircleAvatar(
            backgroundImage: user.profilePhoto != null
                ? NetworkImage(user.profilePhoto!)
                : null,
            child: user.profilePhoto == null ? const Icon(Icons.person) : null,
          ),
          ElevatedButton(
            onPressed: () {
              Future<void> _showImagePickerDialog(BuildContext context) async {
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
        ],
      ),
    );
  }
}
