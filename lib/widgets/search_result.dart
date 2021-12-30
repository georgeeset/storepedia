import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_pedia/cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';
import 'package:store_pedia/widgets/loading_layout.dart';
import 'package:store_pedia/widgets/one_part.dart';

class QueryBody extends StatefulWidget {
  @override
  State<QueryBody> createState() => _QueryBodyState();
}

class _QueryBodyState extends State<QueryBody> {
  final ScrollController _scrollController = ScrollController();

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    var maxScroll = _scrollController.position.maxScrollExtent;
    var currentScroll = _scrollController.offset;
    return currentScroll ==
        maxScroll; // user have scrolled through 90% of scrollcontroller
  }

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartqueryManagerCubit, PartqueryManagerState>(
        builder: (context, state) {
      if (state.queryStatus == QueryStatus.loaded) {
        return StaggeredGridView.countBuilder(
          controller: _scrollController,
          //gridDelegate: SliverStaggeredGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 100,mainAxisSpacing: 10, staggeredTileBuilder: (int index) { return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8); },),
          itemCount: state.hasReachedMax
              ? state.response.length
              : state.response.length + 1, // for displaying loading indicator.
          //shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index >= state.response.length) {
              return state.hasReachedMax == true
                  ? Container()
                  : Shimmer(
                      child: Card(color: Colors.blue),
                      gradient:
                          LinearGradient(colors: [Colors.green, Colors.teal]));
            } else {
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
            //Image.asset('assets/gifs/animated_search.gif'),
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
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollFunction)
      ..dispose();
    super.dispose();
  }
}
