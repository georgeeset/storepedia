import 'package:about/about.dart';
import 'package:storepedia/cubit/recent_item_cubit/cubit/recentitems_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/cubit/usermanager_cubit.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/widgets/input_editor.dart';
import 'package:storepedia/widgets/menu_tiles.dart';
import 'package:storepedia/widgets/one_part.dart';

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
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0)),
                  ),
                  child: LayoutBuilder(builder: (context, constraints) {
                    if (constraints.maxWidth < 700) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MenuTiles(
                                sizeData: sizeData,
                                horizontalListWidth: horizontalListWidth,
                                horizontalListHeight: horizontalListHeight),
                            const Divider(),
                            const Text('Recently Added Store Items'),
                            BlocBuilder<RecentItemsCubit, List<Part>>(
                              builder: (context, recentItemState) {
                                return Wrap(
                                  direction: Axis.horizontal,
                                  children: recentItemState
                                      .map((e) => SizedBox(
                                            width: 150,
                                            height: 200,
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
                                horizontal: 50,
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
                          SingleChildScrollView(
                            child: Container(
                              width: sizeData.width / 1.7,
                              constraints: const BoxConstraints(maxWidth: 1000),
                              alignment: Alignment.topRight,
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              child: BlocBuilder<RecentItemsCubit, List<Part>>(
                                builder: (context, recentItemState) {
                                  return Wrap(
                                    direction: Axis.horizontal,
                                    children: recentItemState
                                        .map((e) => Container(
                                            width: sizeData.width / 4,
                                            height: sizeData.width / 2.8,
                                            constraints: const BoxConstraints(
                                              maxHeight: 360,
                                              maxWidth: 250,
                                              minHeight: 200,
                                              minWidth: 150,
                                            ),
                                            child: OnePart(part: e)))
                                        .toList(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  })
                  //child: TextField(),
                  ),
            ),
          ],
        ),
      ),
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
        width: sizeData.width / 5,
        height: sizeData.width / 5,
        constraints: const BoxConstraints(
          minWidth: 80,
          minHeight: 80,
          maxHeight: 120,
          maxWidth: 120,
        ),
        padding: const EdgeInsets.all(5.0),
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
