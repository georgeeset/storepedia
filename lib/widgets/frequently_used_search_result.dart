import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_pedia/cubit/department_selector_cubit/department_selector_cubit.dart';
import 'package:store_pedia/cubit/query_common_items_cubit/query_common_items_cubit.dart';
import 'package:store_pedia/widgets/loading_layout.dart';

import 'one_part.dart';

class FrequentlyUsedSearchResult extends StatefulWidget {
  const FrequentlyUsedSearchResult({Key? key}) : super(key: key);

  @override
  State<FrequentlyUsedSearchResult> createState() =>
      _FrequentlyUsedSearchResultState();
}

class _FrequentlyUsedSearchResultState
    extends State<FrequentlyUsedSearchResult> {
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

    String dept = context.read<DepartmentSelectorCubit>().state;
    context.read<QueryCommonItemsCubit>().getCommonItems(dept);
    _scrollController.addListener(_scrollFunction);
  }

  void _scrollFunction() {
    if (_isBottom) {
      String selected = context.read<DepartmentSelectorCubit>().state;
      context.read<QueryCommonItemsCubit>().moreCommonItems(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QueryCommonItemsCubit, QueryCommonItemsState>(
      listener: (context, state) {
        // todo remove drive
      },
      builder: (context, state) {
        if (state.queryStatus == QueryStatus.loading) {
          return LoadingLayout();
        }
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
                return state.hasReachedMax == true
                    ? Container()
                    : Shimmer(
                        child: Card(color: Colors.blue),
                        gradient: LinearGradient(
                            colors: [Colors.green, Colors.teal]));
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
        } else {
          return Container();
        }
      },
    );
  }
}
