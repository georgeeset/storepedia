import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:storepedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:storepedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/screens/Profile_page/profile_page.dart';
import 'package:storepedia/screens/add_item_page/add_item_page.dart';
import 'package:storepedia/screens/exhausted_items_page/exhausted_items_page.dart';

import 'package:storepedia/constants/string_constants.dart' as string_constants;
import 'package:storepedia/constants/number_constants.dart' as number_constants;
import 'package:storepedia/screens/search_page/search_page.dart';
import 'package:storepedia/widgets/input_editor.dart';
import 'package:storepedia/widgets/warining_dialog.dart';

class MenuTiles extends StatelessWidget {
  const MenuTiles(
      {super.key,
      required this.sizeData,
      required this.horizontalListWidth,
      required this.horizontalListHeight,
      this.itemsDirection = Axis.horizontal});

  final Size sizeData;
  final double horizontalListWidth;
  final double horizontalListHeight;
  final Axis itemsDirection;

  @override
  Widget build(BuildContext context) {
    void addItemFunction() async {
      var score = context.read<FormLevelCubit>().state;
      if (score > 0) {
        var dialogResult = await WarningDialog.boolActionsDialog(
          context: context,
          titleText: string_constants.dialogTitleAddPart,
          bodyText: string_constants.dialogBodyAddPart,
          goodOption: string_constants.yes, //false
          badOption: string_constants.no, //true
        );

        if (!context.mounted) return;

        if (dialogResult == true) {
          context.read<EditItemCubit>().clearPart();
          context.read<PhotomanagerBloc>().add(RemovePhotoEvent());
          context.read<FormLevelCubit>().clearScore();
          Navigator.pushNamed(context, AddItemPage.routName);
        } else {
          Navigator.pushNamed(context, AddItemPage.routName);
        }
      } else {
        Navigator.pushNamed(context, AddItemPage.routName);
      }
    }

    return Wrap(
      direction: itemsDirection,
      // gridDelegate:
      //     const SliverGridDelegateWithFixedCrossAxisCount(
      //         crossAxisCount: 3),
      children: [
        MenuItem(
          sizeData: sizeData,
          itemIcon: Icons.search,
          itemText: 'Search Store Item',
          onTapAction: () async {
            Navigator.pushNamed(context, SearchPage.routName);
          },
        ),

        BlocConsumer<UserManagerCubit, UserManagerState>(
            builder: (context, state) {
          if (state is UserManagerInitial || state is UserLoadingState) {
            return MenuItem(
                sizeData: sizeData,
                itemIcon: Icons.timelapse,
                itemText: 'Loading',
                onTapAction: () async {
                  context.read<UserManagerCubit>().retryLoading();
                });
          }

          if (state is UserLoadingErrorState) {
            return MenuItem(
                sizeData: sizeData,
                itemIcon: Icons.error,
                itemText: 'Error',
                onTapAction: () async {
                  context.read<UserManagerCubit>().retryLoading();
                });
          }

          if (state is UserLoadedState && !state.userData.hasName()) {
            return MenuItem(
              sizeData: sizeData,
              itemIcon: Icons.call_to_action,
              itemText: string_constants.completeYourProfile,
              onTapAction: () {
                SignupFormDialog.formDialog(
                  context: context,
                  onSubmit: (value) {
                    var userData = context.read<UserManagerCubit>().state;
                    if (userData is UserLoadedState) {
                      context.read<UserManagerCubit>().updateUserName(
                            fullName: value,
                            userData: userData.userData,
                          );
                    }
                  },
                  title: 'Your Name In Full \n This cannot be edited',
                );
              },
            );
          }

          return MenuItem(
              sizeData: sizeData,
              itemIcon: Icons.add,
              itemText: 'Add Item',
              onTapAction: () async {
                addItemFunction();
              });
        }, listener: (BuildContext context, UserManagerState state) {
          // display dialog for user name if user has no name
          // next display dialog if user has name but has no company name
          // display dialog if user has not verified his email
          // ...

          if (state is UserLoadedState) {
            if (!state.userData.hasBranch() ||
                !state.userData.hasCompany() ||
                !state.userData.hasBranch() ||
                !state.userData.hasName()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.redAccent,
                  duration:
                      Duration(seconds: number_constants.errorSnackBarDelay),
                  content: Text('Your Profile is not complete yet !'),
                ),
              );
            }
          }
        }),

        // ElevatedButton(
        //     onPressed: () => context
        //         .read<AuthenticationBloc>()
        //         .add(SignOutEvent()),
        //     child: Text('Signout'))

        MenuItem(
            sizeData: sizeData,
            itemIcon: Icons.hourglass_empty,
            itemText: 'Exhausted Items',
            onTapAction: () {
              Navigator.pushNamed(context, ExhaustedItemsPage.routName);
            }),

        MenuItem(
          sizeData: sizeData,
          itemIcon: Icons.person,
          itemText: 'Profile',
          onTapAction: () async {
            Navigator.pushNamed(context, ProfilePage.routName);
          },
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {super.key,
      required this.sizeData,
      required this.itemIcon,
      required this.itemText,
      required this.onTapAction});

  final Size sizeData;
  final IconData itemIcon;
  final String itemText;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          splashColor: Colors.blue,
          onTap: onTapAction,
          child: Container(
            width: sizeData.width / 5,
            height: sizeData.width / 5,
            constraints: const BoxConstraints(
              minWidth: 90,
              minHeight: 90,
              maxHeight: 130,
              maxWidth: 130,
            ),
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  itemIcon,
                  size: 30,
                ),
                Text(
                  itemText,
                  // overflow: TextOverflow.ellipsis,
                  style: const TextStyle().copyWith(fontSize: 10),
                  softWrap: true,
                ),
              ],
            ),
          )),
    );
  }
}
