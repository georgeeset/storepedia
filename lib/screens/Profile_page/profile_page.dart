import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/widgets/onliine_avatar.dart';
import 'package:storepedia/widgets/page_layout.dart';

import '../../cubit/fellow_users_cubit/fellow_users_cubit.dart';
import '../../widgets/input_editor.dart';

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
        DataRow(
          rowKey: 'Company:',
          rowValue: data.company,
          editAction: () {
            SignupFormDialog.formDialog(
              context: context,
              onSubmit: (value) {
                var userData = context.read<UserManagerCubit>().state;
                if (userData is UserLoadedState) {
                  // ensure company name is safe before saving
                  if (!RegExp(r"^[A-Za-z\s]+$").hasMatch(value)) return;
                  context.read<UserManagerCubit>().updateCompanyName(
                        companyName: value.trim(),
                        userData: userData.userData,
                      );
                }
              },
              title:
                  'Company Name\ndetermines the where your data is stored.\nMust contain Aphabet and space only',
            );
          },
        ),
        DataRow(
          rowKey: 'Branch:',
          rowValue: data.branch,
          editAction: () {
            SignupFormDialog.formDialog(
              context: context,
              onSubmit: (value) {
                var userData = context.read<UserManagerCubit>().state;
                if (userData is UserLoadedState) {
                  context.read<UserManagerCubit>().updateCompanyBranch(
                        companyBranch: value,
                        userData: userData.userData,
                      );
                }
              },
              title:
                  'Company Branch\nYour company branch separates your team from other location',
            );
          },
        ),
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
            Text(
              'Find your Co-Workers',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                        myAccount: data,
                        user: user,
                        key: ValueKey(user.userId),
                      ),
                    )
                    .toList(),
              );
            } else if (state.queryStatus == QueryStatus.error) {
              return Text(state.errorMessage);
            } else if (state.queryStatus == QueryStatus.loading) {
              return const LinearProgressIndicator();
            } else if (state.queryStatus == QueryStatus.noResult) {
              return const Text(
                  'You are all alone!, No co-workers.\nInvite your co-workers to enjoy full features');
            }
            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}

class DataRow extends StatelessWidget {
  const DataRow(
      {super.key, required this.rowKey, this.rowValue, this.editAction});
  final String rowKey;
  final String? rowValue;
  final Function? editAction;

  @override
  Widget build(BuildContext context) {
    if (rowValue != null) {
      return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              rowKey,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            SelectableText(rowValue ?? ''),
            const SizedBox(
              width: 30,
            ),
            editAction != null
                ? IconButton(
                    onPressed: () => editAction!(),
                    icon: const Icon(Icons.edit))
                : const SizedBox()
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class FellowUserCard extends StatelessWidget {
  const FellowUserCard(
      {super.key, required this.myAccount, required this.user});

  final UserModel user;
  final UserModel myAccount;

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
            const SizedBox(
              width: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  myAccount.userId == user.userId ? 'You' : user.userName ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(user.email ?? ''),
                const SizedBox(height: 8),
                Text('Location: ${user.branch}'),
                Row(
                  children: [
                    Text('Access Level: ${user.accessLevel}'),
                    const SizedBox(
                      width: 20,
                    ),
                    myAccount.accessLevel > user.accessLevel
                        ? ElevatedButton(
                            onPressed: () {
                              context.read<UserManagerCubit>().upgradeCoWorker(
                                  myAccount: myAccount, coWorker: user);
                            },
                            child: const Text("+Add"))
                        : const SizedBox()
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
