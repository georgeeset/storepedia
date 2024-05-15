import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:storepedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:storepedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:storepedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:storepedia/cubit/recent_item_cubit/cubit/recentitems_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:storepedia/screens/Profile_page/profile_page.dart';
import 'package:storepedia/screens/add_item_page/add_item_page.dart';
import 'package:storepedia/screens/exhausted_items_page/exhausted_items_page.dart';
import 'package:storepedia/screens/home_page/home_page.dart';

import 'package:storepedia/constants/string_constants.dart' as string_constants;
import 'package:storepedia/constants/number_constants.dart' as number_constants;
import 'package:storepedia/screens/search_page/search_page.dart';
import 'package:storepedia/widgets/loading_indicator.dart';
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
          listener: (context, state) {
            // check if UserManager has loaded and give option for reloading
            // if failed, reload option will be provided.
            var authSample = context.read<AuthenticationBloc>().state;

            if (state is UserLoadingErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.pink,
                    duration: const Duration(
                        seconds: number_constants.errorSnackBarDelay),
                    content: const Text(string_constants.errorLoadingProfile),
                    action: SnackBarAction(
                      label: 'Reload',
                      onPressed: () {
                        context.read<UserManagerCubit>().retryLoading();
                      },
                    )),
              );
            }

            // if usermanagerState is loaded,
            // if loaded, go adhead and display
            //recent parts added to db

            if (state is UserLoadedState) {
              context.read<RecentItemsCubit>().listenForRecentParts();
            }

            /// this check should be the last one so we confirm how serious the
            /// user is before app access is checked.

            if (state is UserLoadedState &&
                state.userData.accessLevel == 0 &&
                state.userData.hasName() &&
                authSample is AuthenticatedState &&
                authSample.user.emailVerified) {
              WarningDialog.boolActionsDialog(
                      context: context,
                      titleText: string_constants.noPermisionTitle,
                      bodyText: string_constants.noPermisionBody,
                      goodOption: 'OK',
                      isDismissible: false)
                  .then(
                (result) =>
                    context.read<AuthenticationBloc>()..add(SignOutEvent()),
              );
            }

            // if you observe device info change,
            // just display snackbar to inform for now.

            if (state is UserLoadedState) {
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                duration: const Duration(
                    seconds: number_constants.errorSnackBarDelay),
                content: const Text(string_constants.deviceChanged),
                // action: SnackBarAction(
                //   label: 'Reload',
                //   onPressed: () {
                //     context
                //         .read<UserManagerCubit>()
                //         .retryLoading();
                //   },
                // ),
              );
            }
          },
          builder: (context, state) {
            //loading indicatior if loading
            if (state is UserLoadingState) {
              return Container(
                width: sizeData.width / 5,
                height: sizeData.width / 5,
                constraints: const BoxConstraints(
                  minWidth: 90,
                  minHeight: 90,
                  maxHeight: 130,
                  maxWidth: 130,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Center(child: LoadingIndicator()),
              );
            }

            // deside what to display if user is loaded
            // and level of user's registeration
            if (state is UserLoadedState) {
              var user = context.read<AuthenticationBloc>().state;

              if (state.userData.hasName()) {
                if (user is AuthenticatedState) {
                  if (user.user.emailVerified) {
                    return MenuItem(
                      sizeData: sizeData,
                      itemIcon: Icons.add,
                      itemText: 'Add Item',
                      onTapAction: addItemFunction,
                    );
                  } else {
                    return Container(
                      width: horizontalListWidth,
                      height: horizontalListHeight,
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        child: const Center(
                          child: Text(
                            string_constants.emailVerificationMessage,
                            softWrap: true,
                          ),
                        ),
                        onTap: () {
                          context.read<UserManagerCubit>().verifyEmail();
                        },
                      ),
                    );
                  }
                }
              } else {
                return EditProfileOption(
                  sizeData: sizeData,
                );
              }
            }
            if (state is EmailVerificationSentState) {
              return Container(
                  width: horizontalListWidth,
                  height: horizontalListHeight,
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    child: Center(
                      child: Text(
                        '${string_constants.emailVerificationSentMessage} ${state.email}',
                        softWrap: true,
                      ),
                    ),
                    onTap: () {
                      context.read<AuthenticationBloc>().add(SignOutEvent());
                    },
                  ));
            }
            return SizedBox(
              width: horizontalListWidth,
              height: horizontalListHeight,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    context.read<UserManagerCubit>().retryLoading();
                  },
                  icon: const Icon(Icons.error, size: 40),
                ),
              ),
            );
          },
        ),
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
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle().copyWith(fontSize: 10),
                  softWrap: true,
                ),
              ],
            ),
          )),
    );
  }
}
