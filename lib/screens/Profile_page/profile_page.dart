import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/widgets/onliine_avatar.dart';
import 'package:storepedia/widgets/page_layout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static String routName = '/profile_page';

  @override
  Widget build(BuildContext context) {
    final Size sizeData = MediaQuery.of(context).size;

    return PageLayout(
      body: SingleChildScrollView(
        child: Container(
          width: sizeData.width,
          height: sizeData.height,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: BlocConsumer<UserManagerCubit, UserManagerState>(
            builder: (context, state) {
              if (state is UserLoadedState) {
                return ProfileData(data: state.userData, sizeData: sizeData);
              } else {
                return Container();
              }
            },
            listener: ((context, state) {}),
          ),
        ),
      ),
      hasBackButton: true,
      title: const Text(
        'Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileData extends StatelessWidget {
  const ProfileData({super.key, required this.data, required this.sizeData});

  final UserModel data;
  final Size sizeData;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          OnlineAvatar(
            editable: true,
            editClicked: () {
              print('hello');
            },
            radius: 60,
            ringColor: Theme.of(context).primaryColor,
            imageLink: data.profilePhoto,
            heroTag: data.profilePhoto ?? 'profile_photo',
          ),
          const SizedBox(
            width: 30,
          ),
        ]),
        const SizedBox(
          height: 10,
        ),
        DataRow(rowKey: 'Full Name:', rowValue: data.userName),
        DataRow(rowKey: 'Email:', rowValue: data.email),
        DataRow(rowKey: 'Company:', rowValue: data.company),
        DataRow(rowKey: 'Branch:', rowValue: data.branch),
        DataRow(
          rowKey: 'User status:',
          rowValue: data.isAdmin ? 'Admin' : 'User',
        ),
        DataRow(
          rowKey: 'Parts Added:',
          rowValue: data.partsAddedCount?.toString(),
        )
      ],
    );
  }
}

class DataRow extends StatelessWidget {
  const DataRow({super.key, required this.rowKey, this.rowValue});
  final String rowKey;
  final String? rowValue;

  @override
  Widget build(BuildContext context) {
    if (rowValue != null) {
      return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              rowKey,
              overflow: TextOverflow.ellipsis,
            ),
            SelectableText(rowValue ?? ''),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
