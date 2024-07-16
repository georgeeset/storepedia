import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/screens/home_page/home_page.dart';
import 'package:storepedia/screens/part_detail_page/part_detail_page.dart';
import 'package:storepedia/screens/search_page/search_page.dart';
import 'package:storepedia/screens/signin_screen/signin_screen.dart';

import '../../bloc/navigation_bloc/navigation_bloc.dart';
import '../profile_edit_page/profile_edit_page.dart';

class PageRouter extends StatefulWidget {
  const PageRouter({super.key});

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationBloc, NavigationState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return PopScope(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: _showCurrentScreen(state.stack.currentRoute),
            ),
            onPopInvoked: (bool didPoP) {
              /// called after pop has happened
            });
      },
    );
  }

  Widget _showCurrentScreen(String screenName) {
    switch (screenName) {
      case HomePage.routeName:
        return const HomePage();
      case PartDetailPage.routeName:
        return const PartDetailPage();
      case ProfileEditPage.routeName:
        return const ProfileEditPage();
      case SigninScreen.routeName:
        return const SigninScreen();
      case SearchPage.routeName:
        return const SearchPage();
      default:
        return const SigninScreen();
    }
  }
}
