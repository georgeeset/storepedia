import 'package:about/about.dart';
import 'package:store_pedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:store_pedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:store_pedia/cubit/department_selector_cubit/department_selector_cubit.dart';
import 'package:store_pedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:store_pedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:store_pedia/cubit/query_common_items_cubit/query_common_items_cubit.dart';
import 'package:store_pedia/cubit/recent_item_cubit/cubit/recentitems_cubit.dart';
import 'package:store_pedia/cubit/tab_controller_cubit/tab_controller_cubit.dart';
import 'package:store_pedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/model/screenargs.dart';
import 'package:store_pedia/screens/add_item_page/add_item_page.dart';
import 'package:store_pedia/screens/exhausted_items_page/exhausted_items_page.dart';
import 'package:store_pedia/screens/home_page/frequently_used_parts.dart';
import 'package:store_pedia/screens/search_page/search_page.dart';
import 'package:store_pedia/widgets/input_editor.dart';
import 'package:store_pedia/widgets/loading_indicator.dart';
import 'package:store_pedia/widgets/navigation_bar.dart';
import 'package:store_pedia/widgets/one_part.dart';
import 'package:store_pedia/widgets/warining_dialog.dart';

import '../../constants/number_constants.dart' as NumberConstants;
import '../../constants/string_constants.dart' as StringConstants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeData = MediaQuery.of(context).size;
    final double horizontalListWidth = sizeData.width / 2.1;
    final double horizontalListHeight = sizeData.width / 2.1;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: MyNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, SearchPage.routName),
        child: Icon(Icons.search),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: sizeData.width,
                height: NumberConstants.appbarHeight,
                color: Colors.blue,
              ),
            ),
            Positioned(
              top: 10,
              child: Container(
                width: sizeData.width,
                child: Center(
                  child: BlocBuilder<TabControllerCubit, int>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 600),
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.linear,
                        child: state == 0
                            ? SelectableText(
                                'Store Pedia',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(color: Colors.white),
                                onTap: () {
                                  showAboutPage(
                                    context: context,
                                    values: {'version': '1.2', 'year': '2021'},
                                    applicationLegalese:
                                        'Copyright © Flex-Automation, {{ year }}',
                                    applicationDescription: const Text(
                                      StringConstants.aboutApp,
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
                                        image: AssetImage(
                                            'assets/images/splash.png'),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : SizedBox(
                                child: Text(
                                  'Frequently Used Parts',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: NumberConstants.appbarHeight -
                  NumberConstants.bodyOverlapHeight,
              left: 0,
              child: Container(
                  width: sizeData.width,
                  height: sizeData.height - NumberConstants.appbarHeight,
                  //padding: EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: BlocBuilder<TabControllerCubit, int>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        reverseDuration: Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: state == 0
                            ? homeListView(sizeData, horizontalListWidth,
                                horizontalListHeight)
                            : MultiBlocProvider(
                                providers: [
                                  BlocProvider<DepartmentSelectorCubit>(
                                    create: (context) =>
                                        DepartmentSelectorCubit(),
                                  ),
                                  BlocProvider<QueryCommonItemsCubit>(
                                    create: (context) =>
                                        QueryCommonItemsCubit(),
                                    lazy: false,
                                  ),
                                ],
                                child: FrequentlyUsedParts(),
                              ),
                      );
                    },
                  )
                  //child: TextField(),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  ListView homeListView(
    Size sizeData,
    double horizontalListWidth,
    double horizontalListHeight,
  ) {
    return ListView(
      children: [
        Divider(),
        Container(
          height: sizeData.height / 2.8,
          color: Colors.black12,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Card(
              //   child: InkWell(
              //     child: Container(
              //       width: horizontalListWidth,
              //       height: horizontalListWidth,
              //       child: Center(
              //         child: Column(
              //           mainAxisAlignment:
              //               MainAxisAlignment.center,
              //           children: [
              //             Icon(
              //               Icons.search,
              //               size: 54,
              //             ),
              //             Text(
              //               'Search Store Item',
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     splashColor: Colors.blue,
              //     onTap: () {
              //       Navigator.pushNamed(
              //           context, SearchPage.routName);
              //     },
              //   ),
              // ),
              Card(
                child: BlocConsumer<UserManagerCubit, UserManagerState>(
                  listener: (context, state) {
                    // check if UserManager has loaded and give option for reloading
                    // if failed, reload option will be provided.
                    var authSample = context.read<AuthenticationBloc>().state;

                    if (state is UserLoadingErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.pink,
                            duration: Duration(
                                seconds: NumberConstants.errorSnackBarDelay),
                            content: Text(StringConstants.errorLoadingProfile),
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
                              titleText: StringConstants.noPermisionTitle,
                              bodyText: StringConstants.noPermisionBody,
                              goodOption: 'OK',
                              isDismissible: false)
                          .then(
                        (result) => context.read<AuthenticationBloc>()
                          ..add(SignOutEvent()),
                      );
                    }

                    // if you observe device info change,
                    // just display snackbar to inform for now.

                    if (state is UserLoadedState &&
                        state.userData.deviceId == state.actualDeviceInfo) {
                      SnackBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        duration: Duration(
                            seconds: NumberConstants.errorSnackBarDelay),
                        content: Text(StringConstants.deviceChanged),
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
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(child: LoadingIndicator()),
                      );
                    }

                    // deside what to display if user is loaded
                    // and level of user's registeration
                    if (state is UserLoadedState) {
                      var user = context.read<AuthenticationBloc>().state;

                      if (state.userData.hasName()) {
                        if (user is AuthenticatedState) {
                          if (user.user.emailVerified) {
                            return AddStoreItem(sizeData: sizeData);
                          } else {
                            return Container(
                              width: horizontalListWidth,
                              height: horizontalListHeight,
                              color: Colors.amber[50],
                              padding: EdgeInsets.all(10.0),
                              child: InkWell(
                                child: Center(
                                  child: Text(
                                    StringConstants.emailVerificationMessage,
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
                          color: Colors.amber[200],
                          padding: EdgeInsets.all(10.0),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                '${StringConstants.emailVerificationSentMessage} ${state.email}',
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
                    return Container(
                      width: horizontalListWidth,
                      height: horizontalListHeight,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            context.read<UserManagerCubit>().retryLoading();
                          },
                          icon: Icon(Icons.error, size: 42),
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
        Divider(),
        Align(
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
                    .map((e) => Container(width: 150, child: OnePart(part: e)))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AddStoreItem extends StatelessWidget {
  const AddStoreItem({
    Key? key,
    required this.sizeData,
  }) : super(key: key);

  final Size sizeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      child: Container(
        width: sizeData.width / 2.1,
        height: sizeData.width / 2.1,
        child: Column(
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
            titleText: StringConstants.dialogTitleAddPart,
            bodyText: StringConstants.dialogBodyAddPart,
            goodOption: StringConstants.yes, //false
            badOption: StringConstants.no, //true
          );

          if (dialogResult == true) {
            context.read<EditItemCubit>().clearPart();
            context.read<PhotomanagerBloc>().add(RemovePhotoEvent());
            context.read<FormLevelCubit>().clearScore();

            Navigator.pushNamed(context, AddItemPage.routName,
                arguments: ScreenArguments('Edit', Reason.newPart));
          } else {
            Navigator.pushNamed(context, AddItemPage.routName,
                arguments: ScreenArguments('Edit', Reason.newPart));
          }
        } else {
          Navigator.pushNamed(context, AddItemPage.routName,
              arguments: ScreenArguments('Edit', Reason.newPart));
        }
      },
    );
  }
}

class EditProfileOption extends StatelessWidget {
  const EditProfileOption({required this.sizeData, Key? key}) : super(key: key);
  final Size sizeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      child: Container(
        width: sizeData.width / 2.1,
        height: sizeData.width / 2.1,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 54,
            ),
            Text(
              StringConstants.completeYourProfile,
              style: Theme.of(context).textTheme.headline6,
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
    Key? key,
    required this.sizeData,
  }) : super(key: key);

  final Size sizeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      child: Container(
        width: sizeData.width / 2.1,
        height: sizeData.width / 2.1,
        child: Column(
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
