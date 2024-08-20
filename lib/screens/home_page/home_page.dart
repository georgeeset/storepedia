import 'package:about/about.dart';
import 'package:storepedia/cubit/recent_item_cubit/recentitems_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/widgets/menu_tiles.dart';
import 'package:storepedia/widgets/one_part.dart';

import '../../bloc/authentication_bloc/bloc/authentication_bloc.dart';
import '../../bloc/signin_option_bloc/bloc/signinoption_bloc.dart';
import '../../constants/number_constants.dart' as number_constants;
import '../../constants/string_constants.dart' as string_constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/email_verification.dart';
import '../signin_screen/signin_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String routeName = '/';
  static String name = 'home';
  static String jumpRoute = '/jump-to/:path';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        builder: ((context, state) {
      if (state is AuthenticatedState) {
        if (!state.user.emailVerified) {
          return EmailVerification(email: state.user.email!);
        }
        return BlocProvider<RecentItemsCubit>(
          create: (context) => RecentItemsCubit(),
          child: const HomeScreen(),
        );
      } else {
        if (state is AuthenticationInitial) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              alignment: Alignment.center,
              child: Image.asset('assets/images/main_logo.jpg'),
            ),
          );
        } else {
          return MultiBlocProvider(
            providers: [
              BlocProvider<SigninoptionBloc>(
                create: (context) => SigninoptionBloc(),
              ),
            ],
            child: const SigninScreen(),
          );
        }
      }
    }), listener: (context, authState) {
      if (authState is AuthenticatedState) {
        // start getting the user's information from database
        context.read<UserManagerCubit>().getUser(authState.user);
      }
      if (authState is AuthenticationFailedState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.pink,
            duration: Duration(seconds: number_constants.errorSnackBarDelay),
            // content: Text('Failed !\n${authState.errorMessage}'),
            content: Text('Invalid Email or Password'),
          ),
        );
      }
    });
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeData = MediaQuery.of(context).size;
    final double horizontalListWidth = sizeData.width / 2.1;
    final double horizontalListHeight = sizeData.width / 2.1;

    var userInfo = context.read<UserManagerCubit>().state;
    var userLoaded = userInfo is UserLoadedState;

    if (userLoaded) {
      context.read<RecentItemsCubit>().listenForRecentParts(
          company:
              userInfo.userData.company ?? string_constants.partsCollection);
    }

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
                  child: TextButton(
                    child: Text(
                      'Store Pedia',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      displayAbout(context);
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: number_constants.appbarHeight -
                  number_constants.bodyOverlapHeight,
              left: 0,
              child: HomeBody(
                  sizeData: sizeData,
                  horizontalListWidth: horizontalListWidth,
                  horizontalListHeight: horizontalListHeight),
            ),
          ],
        ),
      ),
    );
  }

  void displayAbout(BuildContext context) async {
    return showAboutPage(
      context: context,
      values: {'version': '3.0.1', 'year': '2021'},
      applicationLegalese: 'Copyright © CXG Technologies, {{ year }}',
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
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.sizeData,
    required this.horizontalListWidth,
    required this.horizontalListHeight,
  });

  final Size sizeData;
  final double horizontalListWidth;
  final double horizontalListHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: sizeData.width,
        height: sizeData.height - number_constants.appbarHeight,
        //padding: EdgeInsets.symmetric(vertical: 5.0)
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < number_constants.maxMobileView) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MenuTiles(
                    sizeData: sizeData,
                    horizontalListWidth: horizontalListWidth,
                    horizontalListHeight: horizontalListHeight,
                  ),
                  const Divider(),
                  const Text('Recently Added Store Items'),
                  BlocBuilder<RecentItemsCubit, List<Part>>(
                    builder: (context, recentItemState) {
                      return Wrap(
                        direction: Axis.horizontal,
                        children: recentItemState
                            .map((e) => SizedBox(
                                  width: number_constants.onePartwidth,
                                  height: number_constants.onePartHeight,
                                  child: OnePart(part: e),
                                ))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: MenuTiles(
                      sizeData: sizeData,
                      horizontalListWidth: horizontalListWidth,
                      horizontalListHeight: horizontalListHeight,
                      itemsDirection: Axis.vertical,
                    ),
                  ),
                ),
                const Spacer(),
                SingleChildScrollView(
                  child: Container(
                    width: sizeData.width / 1.5,
                    margin: const EdgeInsets.only(right: 40.0),
                    constraints: const BoxConstraints(maxWidth: 1000),
                    alignment: Alignment.topRight,
                    // padding: const EdgeInsetsDirectional.symmetric(
                    //   horizontal: 10.0,
                    //   vertical: 10.0,
                    // ),
                    child: BlocBuilder<RecentItemsCubit, List<Part>>(
                      builder: (context, recentItemState) {
                        var userInfo = context.read<UserManagerCubit>().state;
                        if (userInfo is UserLoadedState &&
                            recentItemState.isEmpty) {
                          context.read<RecentItemsCubit>().listenForRecentParts(
                              company: userInfo.userData.company ?? 'parts');
                        }
                        return Wrap(
                          direction: Axis.horizontal,
                          children: recentItemState
                              .map(
                                (e) => Container(
                                  // width: sizeData.width / 4,
                                  // height: sizeData.width / 2.8,
                                  constraints: const BoxConstraints(
                                    // maxHeight: 360,
                                    // maxWidth: 250,
                                    // minHeight: 200,
                                    // minWidth: 150,
                                    maxHeight:
                                        number_constants.onePartMaxHeight,
                                  ),
                                  child: AspectRatio(
                                      aspectRatio: 3 / 5,
                                      child: OnePart(part: e)),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
              ],
            );
          }
        })
        //child: TextField(),
        );
  }
}
