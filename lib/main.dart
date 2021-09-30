import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:store_pedia/bloc/part_upload_wizard/bloc/partuploadwizard_bloc.dart';
import 'package:store_pedia/bloc/photo_manager_bloc/photomanager_bloc.dart';
import 'package:store_pedia/bloc/photo_upload_bloc.dart/cubit/photoupload_cubit.dart';
import 'package:store_pedia/bloc/signin_option_bloc/bloc/signinoption_bloc.dart';
import 'package:store_pedia/cubit/connectivity_cubit/cubit/connectivity_cubit.dart';
import 'package:store_pedia/cubit/form_level_cubit/formlevel_cubit.dart';
import 'package:store_pedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:store_pedia/screens/add_item_page/add_item_page.dart';
import 'package:store_pedia/screens/home_page/home_page.dart';
import 'package:store_pedia/screens/search_page/search_page.dart';
import 'package:store_pedia/screens/signin_screen/signin_screen.dart';
import 'cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

import 'cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
        BlocProvider(
          create: (context) => AuthenticationBloc(),
          lazy: false,
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<UserManagerCubit>(
          create: (context) => UserManagerCubit(),
        ),
        BlocProvider<PartuploadwizardBloc>(
          create: (context) => PartuploadwizardBloc(),
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
          SearchPage.routName: (context) => BlocProvider<PartquerymanagerCubit>(
                create: (context) => PartquerymanagerCubit(),
                child: SearchPage(),
              ),
          AddItemPage.routName: (context) => AddItemPage(),
          //UpdatePage.routName:(context) => UpdatePage(),
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
                      return HomePage();
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
                  }), listener: (context, state) {
                    if (state is AuthenticatedState) {
                      // start getting the user's information from database
                      context.read<UserManagerCubit>().getUser(state.user);
                    }
                    if (state is AuthenticationFailedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.pink,
                          duration: Duration(
                              seconds: NumberConstants.errorSnackBarDelay),
                          content:
                              Text('Login Failed !\n${state.errorMessage}'),
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
