import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';
import 'package:store_pedia/widgets/page_layout.dart';
import 'package:store_pedia/widgets/search_result.dart';

class SearchPage extends StatefulWidget {
  static String routName = '/search_page';
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    Size pageSize = MediaQuery.of(context).size;
    return PageLayout(
      title: Container(
          margin: EdgeInsets.only(left: 10),
          width: pageSize.width / 1.3,
          child: SearchDon()),
      hasBackButton: true,
      body: QueryBody(),
    );
  }
}

class SearchDon extends StatefulWidget {
  const SearchDon({Key? key}) : super(key: key);

  @override
  State<SearchDon> createState() => _SearchDonState();
}

class _SearchDonState extends State<SearchDon> {
  late TextEditingController controller;

  @override
  void initState() {
    var searchState = context.read<PartqueryManagerCubit>().state;
    controller = TextEditingController(text: searchState.searchString);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
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
          context.read<PartqueryManagerCubit>().attemptQuery(text);
        }
      },
      onSubmitted: (text) {
        context.read<PartqueryManagerCubit>().attemptQuery(text);
      },
    );
  }
}
