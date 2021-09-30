import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';
import 'package:store_pedia/widgets/page_layout.dart';

class SearchPage extends StatelessWidget {
  static String routName = '/search_page';
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size pageSize = MediaQuery.of(context).size;
    return PageLayout(
      title: Container(
          margin: EdgeInsets.only(left: 10),
          width: pageSize.width / 1.3,
          child: SearchDon()),
      hasBackButton: true,
      body: BlocBuilder<PartquerymanagerCubit, PartquerymanagerState>(
          builder: (context, state) {
        if (state is PartqueryloadedState) {
          return ListView.builder(
              itemCount: state.response.length,
              itemBuilder: (context, index) =>
                  Text(state.response[index].partName!));
        }
        return Container();
      }),
    );
  }
}

class SearchDon extends StatelessWidget {
  const SearchDon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isCollapsed: true,
        hintText: 'Search Part',
        contentPadding: EdgeInsets.all(5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    
      onChanged: (text)=>context.read<PartquerymanagerCubit>().attemptQuery(text),
      
    );
  }
}
