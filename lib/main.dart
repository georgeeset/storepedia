import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storepedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:storepedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';
import 'package:storepedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:storepedia/cubit/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:storepedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/firebase_options.dart';
import 'cubit/edit_item_cubit/edititem_cubit.dart';
import 'cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';
import 'cubit/photo_upload_cubit/photoupload_cubit.dart';
import 'screens/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SystemChrome.setSystemUIOverlayS`tyle(const SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.white, // navigation bar color
  //   statusBarColor: Colors.blue, // status bar color
  //   statusBarBrightness: Brightness.dark, //status bar brigtness
  //   statusBarIconBrightness: Brightness.light, //status barIcon Brightness
  //   systemNavigationBarDividerColor:
  //       Colors.black, //Navigation bar divider color
  //   systemNavigationBarIconBrightness: Brightness.dark,
  // )); //navigation bar icon

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<EditItemCubit>(
          create: (context) => EditItemCubit(),
          lazy: false,
        ),
        BlocProvider<FormLevelCubit>(
          create: (context) =>
              FormLevelCubit(editItemCubit: context.read<EditItemCubit>()),
        ),
        BlocProvider<PhotomanagerBloc>(
          create: (context) => PhotomanagerBloc(),
        ),
        BlocProvider<PhotouploadCubit>(
          create: (context) => PhotouploadCubit(),
        ),
        BlocProvider<UserManagerCubit>(
          create: (context) => UserManagerCubit(),
        ),
        BlocProvider<PartuploadwizardBloc>(
          create: (context) => PartuploadwizardBloc(),
        ),
        BlocProvider<PartqueryManagerCubit>(
          create: (context) => PartqueryManagerCubit(),
        ),
        BlocProvider<EditProfileCubit>(create: (context) => EditProfileCubit())
      ],
      child: MaterialApp.router(
        title: 'Store Pedia',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.blue),
        ),
        debugShowCheckedModeBanner: false,
        routeInformationProvider: AppRouter.router.routeInformationProvider,
        routeInformationParser: AppRouter.router.routeInformationParser,
        routerDelegate: AppRouter.router.routerDelegate,
      ),
    );
  }
}
