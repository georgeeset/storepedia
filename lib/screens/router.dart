import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:storepedia/screens/Profile_page/profile_page.dart';
import 'package:storepedia/screens/add_item_page/add_item_page.dart';
import 'package:storepedia/screens/camera_screen/camera_page.dart';
import 'package:storepedia/screens/exhausted_items_page/exhausted_items_page.dart';
import 'package:storepedia/screens/home_page/home_page.dart';
import 'package:storepedia/screens/not_found_page/not_found_page.dart';
import 'package:storepedia/screens/part_detail_page/part_detail_page.dart';
import 'package:storepedia/screens/search_page/search_page.dart';
import '../cubit/exhausted_items_manager_cubit/cubit/exhausteditemsmanager_cubit.dart';
import '../cubit/fellow_users_cubit/fellow_users_cubit.dart';
import '../cubit/mark_bad_part/cubit/mark_bad_part_cubit.dart';
import '../cubit/mark_exhausted_part_cubit/cubit/markexhaustedpart_cubit.dart';
import '../cubit/repitition_cubit/cubit/repitition_cubit.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: HomePage.routeName,
        name: HomePage.name,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: SearchPage.routName,
        name: SearchPage.name,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: ProfilePage.routName,
        name: ProfilePage.name,
        builder: (context, state) => BlocProvider(
          create: (context) => FellowUsersCubit(),
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        path: PartDetailPage.routeName,
        name: PartDetailPage.name,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => MarkpartCubit(),
            ),
            BlocProvider(
              create: (context) => MarkexhaustedpartCubit(),
            ),
          ],
          child: const PartDetailPage(),
        ),
      ),
      GoRoute(
        path: CameraPage.routName,
        name: CameraPage.name,
        builder: (context, state) => const CameraPage(),
      ),
      GoRoute(
        path: AddItemPage.routName,
        name: AddItemPage.name,
        builder: (context, state) => BlocProvider<RepititionCubit>(
          create: (context) => RepititionCubit(),
          child: const AddItemPage(),
        ),
      ),
      GoRoute(
        path: ExhaustedItemsPage.routName,
        name: ExhaustedItemsPage.name,
        builder: (context, state) => BlocProvider<ExhausteditemsmanagerCubit>(
          create: (context) => ExhausteditemsmanagerCubit(),
          child: const ExhaustedItemsPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );

  static GoRouter get router => _router;
}
