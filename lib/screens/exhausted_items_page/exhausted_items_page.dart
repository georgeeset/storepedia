import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:storepedia/cubit/exhausted_items_manager_cubit/cubit/exhausteditemsmanager_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/widgets/loading_layout.dart';
import 'package:storepedia/widgets/one_part.dart';
import 'package:storepedia/widgets/page_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExhaustedItemsPage extends StatelessWidget {
  static String routName = '/exhausted_items_page';

  const ExhaustedItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final Size sizeData = MediaQuery.of(context).size;
    var derived = context.read<UserManagerCubit>().state;
    context.read<ExhausteditemsmanagerCubit>().getExhaustedItems(
          companyName: derived is UserLoadedState
              ? derived.userData.company ?? 'parts'
              : 'parts',
          branch: derived is UserLoadedState
              ? derived.userData.branch ?? 'Ikeja'
              : 'Ikeja',
        );
    return PageLayout(
        title: Text(
          'Exhausted Items',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
        hasBackButton: true,
        body: const ExhaustedBody());
  }
}

class ExhaustedBody extends StatefulWidget {
  const ExhaustedBody({super.key});

  @override
  State<ExhaustedBody> createState() => _ExhaustedBodyState();
}

class _ExhaustedBodyState extends State<ExhaustedBody> {
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
      context.read<ExhausteditemsmanagerCubit>().moreExhaustedItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExhausteditemsmanagerCubit, ExhausteditemsmanagerState>(
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
                  : const Shimmer(
                      gradient:
                          LinearGradient(colors: [Colors.green, Colors.teal]),
                      child: Card(color: Colors.blue),
                    );
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
        return const LoadingLayout();
      }

      if (state.queryStatus == QueryStatus.noResult) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Our Stock seem OK',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Kindly check physically to be double sure.',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
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
