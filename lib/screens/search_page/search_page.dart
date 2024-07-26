import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/widgets/page_layout.dart';
import 'package:storepedia/widgets/search_result.dart';

class SearchPage extends StatelessWidget {
  static String routName = '/search_page';
  final String? searchQuery;
  const SearchPage({this.searchQuery, super.key});

  @override
  Widget build(BuildContext context) {
    Size pageSize = MediaQuery.of(context).size;
    return PageLayout(
      title: Container(
          margin: const EdgeInsets.only(left: 10),
          width: pageSize.width / 1.3,
          child: SearchDon(searchString: searchQuery)),
      hasBackButton: true,
      body: const QueryBody(),
    );
  }
}

class SearchDon extends StatefulWidget {
  const SearchDon({this.searchString, super.key});
  final String? searchString;

  @override
  State<SearchDon> createState() => _SearchDonState();
}

class _SearchDonState extends State<SearchDon> {
  late TextEditingController controller;

  @override
  void initState() {
    var searchState = context.read<PartqueryManagerCubit>().state;
    var userInfo = context.read<UserManagerCubit>().state;

    controller = TextEditingController(text: searchState.searchString);
    var userCompany =
        userInfo is UserLoadedState ? userInfo.userData.company : null;
    if (widget.searchString != null) {
      context
          .read<PartqueryManagerCubit>()
          .attemptQuery(widget.searchString!, userCompany!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isCollapsed: true,
        hintText: 'Search Part',
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      onChanged: (text) {
        if (text.endsWith(' ')) {
          var userInfo = context.read<UserManagerCubit>().state;
          var userCompany =
              userInfo is UserLoadedState ? userInfo.userData.company : null;

          context
              .read<PartqueryManagerCubit>()
              .attemptQuery(text, userCompany!);
        }
      },
      onSubmitted: (text) {
        var userInfo = context.read<UserManagerCubit>().state;
        var userCompany =
            userInfo is UserLoadedState ? userInfo.userData.company : null;
        context.read<PartqueryManagerCubit>().attemptQuery(text, userCompany!);
      },
    );
  }
}
