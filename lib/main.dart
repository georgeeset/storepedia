import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_pedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:store_pedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';
import 'package:store_pedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:store_pedia/bloc/signin_option_bloc/bloc/signinoption_bloc.dart';
import 'package:store_pedia/cubit/connectivity_cubit/cubit/connectivity_cubit.dart';
import 'package:store_pedia/cubit/exhausted_items_manager_cubit/cubit/exhausteditemsmanager_cubit.dart';
import 'package:store_pedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:store_pedia/cubit/recent_item_cubit/cubit/recentitems_cubit.dart';
import 'package:store_pedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:store_pedia/screens/add_item_page/add_item_page.dart';
import 'package:store_pedia/screens/exhausted_items_page/exhausted_items_page.dart';
import 'package:store_pedia/screens/home_page/home_page.dart';
import 'package:store_pedia/screens/part_detail_page/part_detail_page.dart';
import 'package:store_pedia/screens/search_page/search_page.dart';
import 'package:store_pedia/screens/signin_screen/signin_screen.dart';
import 'cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

import 'cubit/mark_bad_part/cubit/mark_bad_part_cubit.dart';
import 'cubit/mark_exhausted_part_cubit/cubit/markexhaustedpart_cubit.dart';
import 'cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';
import 'cubit/photo_upload_cubit/photoupload_cubit.dart';
import 'cubit/repitition_cubit/cubit/repitition_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.blue, // status bar color
    statusBarBrightness: Brightness.dark, //status bar brigtness
    statusBarIconBrightness: Brightness.light, //status barIcon Brightness
    systemNavigationBarDividerColor:
        Colors.black, //Navigation bar divider color
    systemNavigationBarIconBrightness: Brightness.dark,
  )); //navigation bar icon

  HydratedBlocOverrides.runZoned(
    () => runApp(MyApp()),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityCubit>(
          create: (context) => ConnectivityCubit(),
        ),
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
      ],
      child: MaterialApp(
        title: 'Store Pedia',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.blue),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          //MyHomePage.routName : (context)=> MyHomePage(),
          SearchPage.routName: (context) => SearchPage(),
          AddItemPage.routName: (context) => BlocProvider<RepititionCubit>(
                create: (context) => RepititionCubit(),
                child: AddItemPage(),
              ),
          PartDetailPage.routeName: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => MarkpartCubit(),
                  ),
                  BlocProvider(
                    create: (context) => MarkexhaustedpartCubit(),
                  ),
                ],
                child: PartDetailPage(),
              ),
          ExhaustedItemsPage.routName: (context) =>
              BlocProvider<ExhausteditemsmanagerCubit>(
                create: (context) => ExhausteditemsmanagerCubit(),
                child: ExhaustedItemsPage(),
              ),
          // IntroductionPage.routName: (context) => IntroductionPage(),
          // UserTypeSelectionPage.routName: (context) => UserTypeSelectionPage(),
          // ProfilePage.routName: (context) => ProfilePage(),
          // UserSignUpPage.routName: (context) => UserSignUpPage(),
          // ImageShower.routeName:(context)=>ImageShower(),
        },
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? BlocConsumer<AuthenticationBloc, AuthenticationState>(
                    builder: ((context, state) {
                    if (state is AuthenticatedState) {
                      return BlocProvider<RecentItemsCubit>(
                        create: (context) => RecentItemsCubit(),
                        child: HomePage(),
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
                          child: SigninScreen(),
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
                        SnackBar(
                          backgroundColor: Colors.pink,
                          duration: Duration(
                              seconds: NumberConstants.errorSnackBarDelay),
                          content:
                              Text('Login Failed !\n${authState.errorMessage}'),
                        ),
                      );
                    }
                  })
                : Container(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
