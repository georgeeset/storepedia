import 'package:about/about.dart';
import 'package:storepedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:storepedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:storepedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:storepedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:storepedia/cubit/recent_item_cubit/cubit/recentitems_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/screens/add_item_page/add_item_page.dart';
import 'package:storepedia/screens/exhausted_items_page/exhausted_items_page.dart';
import 'package:storepedia/screens/search_page/search_page.dart';
import 'package:storepedia/widgets/input_editor.dart';
import 'package:storepedia/widgets/loading_indicator.dart';
import 'package:storepedia/widgets/one_part.dart';
import 'package:storepedia/widgets/warining_dialog.dart';

import '../../constants/number_constants.dart' as number_constants;
import '../../constants/string_constants.dart' as string_constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeData = MediaQuery.of(context).size;
    final double horizontalListWidth = sizeData.width / 2.1;
    final double horizontalListHeight = sizeData.width / 2.1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: sizeData.width,
                height: number_constants.appbarHeight,
                color: Colors.blue,
              ),
            ),
            Positioned(
              top: 10,
              child: SizedBox(
                width: sizeData.width,
                child: Center(
                  child: SelectableText(
                    'Store Pedia',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                    onTap: () {
                      showAboutPage(
                        context: context,
                        values: {'version': '1.0', 'year': '2021'},
                        applicationLegalese:
                            'Copyright © Flex-Automation, {{ year }}',
                        applicationDescription: const Text(
                          string_constants.aboutApp,
                          softWrap: true,
                        ),
                        children: const <Widget>[
                          MarkdownPageListTile(
                            icon: Icon(Icons.list),
                            title: Text('StorePedia'),
                            filename: 'CHANGELOG.md',
                          ),
                          LicensesPageListTile(
                            icon: Icon(Icons.favorite),
                          ),
                        ],
                        applicationIcon: const SizedBox(
                          width: 100,
                          height: 100,
                          child: Image(
                            image: AssetImage('assets/images/splash.png'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: number_constants.appbarHeight -
                  number_constants.bodyOverlapHeight,
              left: 0,
              child: Container(
                  width: sizeData.width,
                  height: sizeData.height - number_constants.appbarHeight,
                  //padding: EdgeInsets.symmetric(vertical: 5.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: ListView(
                    children: [
                      const Divider(),
                      Container(
                        height: sizeData.height / 2.5,
                        color: Colors.black12,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Card(
                              child: InkWell(
                                splashColor: Colors.blue,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, SearchPage.routName);
                                },
                                child: SizedBox(
                                  width: horizontalListWidth,
                                  height: horizontalListWidth,
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search,
                                          size: 54,
                                        ),
                                        Text(
                                          'Search Store Item',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: BlocConsumer<UserManagerCubit,
                                  UserManagerState>(
                                listener: (context, state) {
                                  // check if UserManager has loaded and give option for reloading
                                  // if failed, reload option will be provided.
                                  var authSample =
                                      context.read<AuthenticationBloc>().state;

                                  if (state is UserLoadingErrorState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.pink,
                                          duration: const Duration(
                                              seconds: number_constants
                                                  .errorSnackBarDelay),
                                          content: const Text(string_constants
                                              .errorLoadingProfile),
                                          action: SnackBarAction(
                                            label: 'Reload',
                                            onPressed: () {
                                              context
                                                  .read<UserManagerCubit>()
                                                  .retryLoading();
                                            },
                                          )),
                                    );
                                  }

                                  // if usermanagerState is loaded,
                                  // if loaded, go adhead and display
                                  //recent parts added to db

                                  if (state is UserLoadedState) {
                                    context
                                        .read<RecentItemsCubit>()
                                        .listenForRecentParts();
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
                                            titleText: string_constants
                                                .noPermisionTitle,
                                            bodyText: string_constants
                                                .noPermisionBody,
                                            goodOption: 'OK',
                                            isDismissible: false)
                                        .then(
                                      (result) =>
                                          context.read<AuthenticationBloc>()
                                            ..add(SignOutEvent()),
                                    );
                                  }

                                  // if you observe device info change,
                                  // just display snackbar to inform for now.

                                  if (state is UserLoadedState) {
                                    SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      duration: const Duration(
                                          seconds: number_constants
                                              .errorSnackBarDelay),
                                      content: const Text(
                                          string_constants.deviceChanged),
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
                                      width: horizontalListWidth,
                                      height: horizontalListWidth,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: const Center(
                                          child: LoadingIndicator()),
                                    );
                                  }

                                  // deside what to display if user is loaded
                                  // and level of user's registeration
                                  if (state is UserLoadedState) {
                                    var user = context
                                        .read<AuthenticationBloc>()
                                        .state;

                                    if (state.userData.hasName()) {
                                      if (user is AuthenticatedState) {
                                        if (user.user.emailVerified) {
                                          return AddStoreItem(
                                              sizeData: sizeData);
                                        } else {
                                          return Container(
                                            width: horizontalListWidth,
                                            height: horizontalListHeight,
                                            padding: const EdgeInsets.all(10.0),
                                            child: InkWell(
                                              child: const Center(
                                                child: Text(
                                                  string_constants
                                                      .emailVerificationMessage,
                                                  softWrap: true,
                                                ),
                                              ),
                                              onTap: () {
                                                context
                                                    .read<UserManagerCubit>()
                                                    .verifyEmail();
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
                                            context
                                                .read<AuthenticationBloc>()
                                                .add(SignOutEvent());
                                          },
                                        ));
                                  }
                                  return SizedBox(
                                    width: horizontalListWidth,
                                    height: horizontalListHeight,
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          context
                                              .read<UserManagerCubit>()
                                              .retryLoading();
                                        },
                                        icon: const Icon(Icons.error, size: 42),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // ElevatedButton(
                            //     onPressed: () => context
                            //         .read<AuthenticationBloc>()
                            //         .add(SignOutEvent()),
                            //     child: Text('Signout'))
                            Card(child: ExhaustedItems(sizeData: sizeData)),
                          ],
                        ),
                      ),
                      const Divider(),
                      const Align(
                          alignment: Alignment.topCenter,
                          child: Text('Recently Added Store Items')),
                      Container(
                        width: sizeData.width,
                        height: sizeData.height / 3,
                        color: Colors.black12,
                        child: BlocBuilder<RecentItemsCubit, List<Part>>(
                          builder: (context, recentItemState) {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: recentItemState
                                  .map((e) => SizedBox(
                                      width: 150, child: OnePart(part: e)))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                  //child: TextField(),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddStoreItem extends StatelessWidget {
  const AddStoreItem({
    super.key,
    required this.sizeData,
  });

  final Size sizeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      child: SizedBox(
        width: sizeData.width / 2.1,
        height: sizeData.width / 2.1,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 54,
            ),
            Text(
              'Add Item',
            ),
          ],
        ),
      ),
      onTap: () async {
        var score = context.read<FormLevelCubit>().state;
        if (score > 0) {
          var dialogResult = await WarningDialog.boolActionsDialog(
            context: context,
            titleText: string_constants.dialogTitleAddPart,
            bodyText: string_constants.dialogBodyAddPart,
            goodOption: string_constants.yes, //false
            badOption: string_constants.no, //true
          );

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
      },
    );
  }
}

class EditProfileOption extends StatelessWidget {
  const EditProfileOption({required this.sizeData, super.key});
  final Size sizeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      child: Container(
        width: sizeData.width / 2.1,
        height: sizeData.width / 2.1,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 54,
            ),
            Text(
              string_constants.completeYourProfile,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ],
        ),
      ),
      onTap: () {
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
}

class ExhaustedItems extends StatelessWidget {
  const ExhaustedItems({
    super.key,
    required this.sizeData,
  });

  final Size sizeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      child: SizedBox(
        width: sizeData.width / 2.1,
        height: sizeData.width / 2.1,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 54,
            ),
            Text(
              'Exhausted Items',
            ),
          ],
        ),
      ),
      onTap: () async {
        Navigator.pushNamed(context, ExhaustedItemsPage.routName);
      },
    );
  }
}
