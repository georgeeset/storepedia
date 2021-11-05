import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_pedia/cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';
import 'package:store_pedia/widgets/one_part.dart';
import 'package:store_pedia/widgets/page_layout.dart';

class SearchPage extends StatefulWidget {
  static String routName = '/search_page';
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    _scrollController.addListener(_scrollFunction);
  }

  void _scrollFunction() {
    if (_isBottom) {
      context.read<PartqueryManagerCubit>().moreResult();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    var maxScroll = _scrollController.position.maxScrollExtent;
    var currentScroll = _scrollController.offset;
    return currentScroll == maxScroll; // user have scrolled through 90% of scrollcontroller

  }

  @override
  Widget build(BuildContext context) {
    Size pageSize = MediaQuery.of(context).size;
    return PageLayout(
      title: Container(
          margin: EdgeInsets.only(left: 10),
          width: pageSize.width / 1.3,
          child: SearchDon()),
      hasBackButton: true,
      body: BlocBuilder<PartqueryManagerCubit, PartqueryManagerState>(
          builder: (context, state) {
        if (state.queryStatus == QueryStatus.loaded) {
          return StaggeredGridView.countBuilder(
            controller: _scrollController,
            //gridDelegate: SliverStaggeredGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 100,mainAxisSpacing: 10, staggeredTileBuilder: (int index) { return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8); },),
            itemCount: state.hasReachedMax
                ? state.response.length
                : state.response.length +
                    1, // for displaying loading indicator.
            //shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index >= state.response.length) {
                return state.hasReachedMax==true
                ?Container()
                :Shimmer(child: Card(color: Colors.blue), gradient: LinearGradient(colors: [Colors.green, Colors.teal]));
              } 
              else {
                return OnePart(part: state.response[index]);
              }
            },
            crossAxisCount: 2,
            staggeredTileBuilder: (int index) {
              return StaggeredTile.count(1, index.isEven ? 1.4 : 1.8);
            },
            //Text(state.response[index].partName!)
          );
        }

        if (state.queryStatus == QueryStatus.loading) {
          return LoadingLayout();
        }

        if (state.queryStatus == QueryStatus.noResult) {
          return Column(
            children: [
              Image.asset('assets/gifs/animated_search.gif'),
              Text(
                'No Result Found...',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                'Kindly add it when you find it.',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          );
        }
        return Container();
      }),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollFunction)
      ..dispose();
    super.dispose();
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
      controller =TextEditingController(text: searchState.searchString);
   

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

class LoadingLayout extends StatelessWidget {
  const LoadingLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blue.shade50,
      highlightColor: Colors.white,
      child: StaggeredGridView.countBuilder(
        //gridDelegate: SliverStaggeredGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 100,mainAxisSpacing: 10, staggeredTileBuilder: (int index) { return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8); },),
        itemCount: 4,
        //shrinkWrap: true,
        itemBuilder: (context, index) => Card(color: Colors.blue),
        crossAxisCount: 2,
        staggeredTileBuilder: (int index) {
          return StaggeredTile.count(1, index.isEven ? 1.4 : 1.8);
        },
        //Text(state.response[index].partName!)
      ),
    );
  }
}
