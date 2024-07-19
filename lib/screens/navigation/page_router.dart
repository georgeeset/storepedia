import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/screens/home_page/home_page.dart';
import 'package:storepedia/screens/part_detail_page/part_detail_page.dart';
import 'package:storepedia/screens/search_page/search_page.dart';
import 'package:storepedia/screens/signin_screen/signin_screen.dart';
import 'package:storepedia/screens/splash_screen/splash_screen.dart';

import '../../bloc/authentication_bloc/bloc/authentication_bloc.dart';
import '../../bloc/navigation_bloc/navigation_bloc.dart';
import '../../bloc/signin_option_bloc/bloc/signinoption_bloc.dart';
import '../../cubit/recent_item_cubit/recentitems_cubit.dart';
import '../profile_edit_page/profile_edit_page.dart';
import '../../constants/number_constants.dart' as number_constants;

class PageRouter extends StatelessWidget {
  const PageRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, authState) {
            if (authState is AuthenticatedState) {
              context.read<NavigationBloc>().add(PushHomeScreen());
            }

            if (authState is UnauthenticatedState) {
              context.read<NavigationBloc>().add(PushLoginSignupScreen());
            }

            if (authState is AuthenticationFailedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.pink,
                  duration:
                      Duration(seconds: number_constants.errorSnackBarDelay),
                  // content: Text('Failed !\n${authState.errorMessage}'),
                  content: Text('Invalid Email or Password'),
                ),
              );
            }

            if (authState is AuthEmailSentState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.purpleAccent,
                  duration:
                      Duration(seconds: number_constants.errorSnackBarDelay),
                  content: Text('Reset Email Sent !'),
                ),
              );
            }
          }),
        ],
        child: BlocConsumer<NavigationBloc, NavigationState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return PopScope(
                canPop: true,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: _showCurrentScreen(
                    state.stack.currentRoute,
                  ),
                ),
                onPopInvoked: (bool didPoP) {
                  /// called after pop has happened
                });
          },
        ));
  }

  Widget _showCurrentScreen(String screenName) {
    switch (screenName) {
      case HomePage.routeName:
        return BlocProvider<RecentItemsCubit>(
          create: (context) => RecentItemsCubit(),
          child: const HomePage(),
        );
      case SplashScreen.routeName:
        return const SplashScreen();
      case PartDetailPage.routeName:
        return const PartDetailPage();
      case ProfileEditPage.routeName:
        return const ProfileEditPage();
      case SigninScreen.routeName:
        return BlocProvider(
          create: (context) => SigninoptionBloc(),
          child: const SigninScreen(),
        );
      case SearchPage.routeName:
        return const SearchPage();

      default:
        return const SigninScreen();
    }
  }
}
