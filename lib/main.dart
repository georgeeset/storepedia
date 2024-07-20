import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storepedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:storepedia/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:storepedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';
import 'package:storepedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:storepedia/bloc/signin_option_bloc/bloc/signinoption_bloc.dart';
import 'package:storepedia/cubit/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:storepedia/cubit/exhausted_items_manager_cubit/cubit/exhausteditemsmanager_cubit.dart';
import 'package:storepedia/cubit/fellow_users_cubit/fellow_users_cubit.dart';
import 'package:storepedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:storepedia/cubit/recent_item_cubit/recentitems_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/firebase_options.dart';
import 'package:storepedia/screens/add_item_page/add_item_page.dart';
import 'package:storepedia/screens/exhausted_items_page/exhausted_items_page.dart';
import 'package:storepedia/screens/home_page/home_page.dart';
import 'package:storepedia/screens/part_detail_page/part_detail_page.dart';
import 'package:storepedia/screens/profile_edit_page/profile_edit_page.dart';
import 'package:storepedia/screens/search_page/search_page.dart';
import 'package:storepedia/screens/signin_screen/signin_screen.dart';
import 'package:storepedia/screens/splash_screen/splash_screen.dart';
import 'package:storepedia/widgets/email_verification.dart';
import 'cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:storepedia/constants/number_constants.dart' as number_constants;
import 'cubit/mark_bad_part/cubit/mark_bad_part_cubit.dart';
import 'cubit/mark_exhausted_part_cubit/cubit/markexhaustedpart_cubit.dart';
import 'cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';
import 'cubit/photo_upload_cubit/photoupload_cubit.dart';
import 'cubit/repitition_cubit/cubit/repitition_cubit.dart';
import 'screens/Profile_page/profile_page.dart';
import 'screens/camera_screen/camera_page.dart';
import 'screens/navigation/page_router.dart';

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

        BlocProvider(
          create: (context) => UserManagerCubit(),
        ),

        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc('/splashscreen'),
        ),

        // BlocProvider<EditItemCubit>(
        //   create: (context) => EditItemCubit(),
        //   lazy: false,
        // ),
        // BlocProvider<FormLevelCubit>(
        //   create: (context) =>
        //       FormLevelCubit(editItemCubit: context.read<EditItemCubit>()),
        // ),
        // BlocProvider<PhotomanagerBloc>(
        //   create: (context) => PhotomanagerBloc(),
        // ),
        // BlocProvider<PhotouploadCubit>(
        //   create: (context) => PhotouploadCubit(),
        // ),
        // BlocProvider<UserManagerCubit>(
        //   create: (context) => UserManagerCubit(),
        // ),
        // BlocProvider<PartuploadwizardBloc>(
        //   create: (context) => PartuploadwizardBloc(),
        // ),
        // BlocProvider<PartqueryManagerCubit>(
        //   create: (context) => PartqueryManagerCubit(),
        // ),
        // BlocProvider<EditProfileCubit>(create: (context) => EditProfileCubit()),
        // BlocProvider(
        //   create: (context) => NavigationBloc(SplashScreen.routeName),
        // ),
      ],
      child: MaterialApp(
        title: 'Store Pedia',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.blue),
        ),
        debugShowCheckedModeBanner: false,
        // initialRoute: '/',
        // routes: <String, WidgetBuilder>{
        //   //MyHome
        //   //``Page.routName : (context)=> MyHomePage(),
        //   SearchPage.routeName: (context) => const SearchPage(),
        //   AddItemPage.routName: (context) => BlocProvider<RepititionCubit>(
        //         create: (context) => RepititionCubit(),
        //         child: const AddItemPage(),
        //       ),
        //   PartDetailPage.routeName: (context) => MultiBlocProvider(
        //         providers: [
        //           BlocProvider(
        //             create: (context) => MarkpartCubit(),
        //           ),
        //           BlocProvider(
        //             create: (context) => MarkexhaustedpartCubit(),
        //           ),
        //         ],
        //         child: const PartDetailPage(),
        //       ),
        //   ExhaustedItemsPage.routName: (context) =>
        //       BlocProvider<ExhausteditemsmanagerCubit>(
        //         create: (context) => ExhausteditemsmanagerCubit(),
        //         child: const ExhaustedItemsPage(),
        //       ),
        //   // IntroductionPage.routName: (context) => IntroductionPage(),
        //   // UserTypeSelectionPage.routName: (context) => UserTypeSelectionPage(),
        //   ProfilePage.routName: (context) => BlocProvider(
        //         create: (context) => FellowUsersCubit(),
        //         child: const ProfilePage(),
        //       ),
        //   // UserSignUpPage.routName: (context) => UserSignUpPage(),
        //   // ImageShower.routeName:(context)=>ImageShower(),

        //   ProfileEditPage.routeName: (context) => const ProfileEditPage(),

        //   CameraPage.routName: (context) => const CameraPage(),
        // },

        // home: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        //     builder: ((context, state) {
        //   if (state is AuthenticatedState) {
        //     if (!state.user.emailVerified) {
        //       return EmailVerification(email: state.user.email!);
        //     }
        //     return BlocProvider<RecentItemsCubit>(
        //       create: (context) => RecentItemsCubit(),
        //       child: const HomePage(),
        //     );
        //   } else {
        //     if (state is AuthenticationInitial) {
        //       return Scaffold(
        //         backgroundColor: Colors.white,
        //         body: Container(
        //           alignment: Alignment.center,
        //           child: Image.asset('assets/images/main_logo.jpg'),
        //         ),
        //       );
        //     } else {
        //       return MultiBlocProvider(
        //         providers: [
        //           BlocProvider<SigninoptionBloc>(
        //             create: (context) => SigninoptionBloc(),
        //           ),
        //         ],
        //         child: const SigninScreen(),
        //       );
        //     }
        //   }
        // }), listener: (context, authState) {
        //   if (authState is AuthenticatedState) {
        //     // start getting the user's information from database
        //     context.read<UserManagerCubit>().getUser(authState.user);
        //   }
        //   if (authState is AuthenticationFailedState) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(
        //         backgroundColor: Colors.pink,
        //         duration:
        //             Duration(seconds: number_constants.errorSnackBarDelay),
        //         // content: Text('Failed !\n${authState.errorMessage}'),
        //         content: Text('Invalid Email or Password'),
        //       ),
        //     );
        //   }
        // }),

        home: const PageRouter(),
      ),
    );
  }
}
