import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/widgets/onliine_avatar.dart';
import 'package:storepedia/widgets/page_layout.dart';

import '../../cubit/fellow_users_cubit/fellow_users_cubit.dart';

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
                context.read<FellowUsersCubit>().getFellowUsers(state.userData);
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
            editable: false,
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
        ),
        const SizedBox(
          height: 20.0,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Find your Co-Workers'),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        BlocBuilder<FellowUsersCubit, FellowUsersState>(
          builder: (context, state) {
            if (state.queryStatus == QueryStatus.loaded) {
              return Wrap(
                children: state.response
                    .map(
                      (user) => FellowUserCard(
                        user: user,
                      ),
                    )
                    .toList(),
              );
            } else if (state.queryStatus == QueryStatus.error) {
              return Text(state.errorMessage);
            } else {
              return const LinearProgressIndicator();
            }
          },
        ),
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

class FellowUserCard extends StatelessWidget {
  const FellowUserCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OnlineAvatar(
              editable: false,
              radius: 30,
              ringColor: Theme.of(context).primaryColor,
              heroTag: user.userId ?? 'One user With Big head',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(user.email ?? ''),
                const SizedBox(height: 8),
                Text(user.branch ?? ''),
                const SizedBox(height: 8),
                Text("Access Level: ${user.accessLevel.toString()}"),
                // const SizedBox(height: 8),
                // Text(user.bio),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
