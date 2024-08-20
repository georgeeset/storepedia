import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/cubit/part_query_manager.dart/cubit/partquerymanager_cubit.dart';
import 'package:storepedia/widgets/loading_layout.dart';
import 'package:storepedia/widgets/one_part.dart';

import '../constants/number_constants.dart' as number_constants;

class QueryBody extends StatefulWidget {
  const QueryBody({super.key});

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
      print('Is Bottom');
      context.read<PartqueryManagerCubit>().moreResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartqueryManagerCubit, PartqueryManagerState>(
      builder: (context, state) {
        if (state.queryStatus == QueryStatus.loaded &&
            state.response.isNotEmpty) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Wrap(
              direction: Axis.horizontal,
              children: state.response.map((e) {
                return Container(
                  constraints: const BoxConstraints(
                      maxHeight: number_constants.onePartMaxHeight),
                  child: AspectRatio(
                    aspectRatio: 3 / 5,
                    child: OnePart(part: e),
                  ),
                );
              }).toList(),
            ),
          );
          // ..add(Container(
          //     child: state.hasReachedMax
          //         ? null
          //         : const Shimmer(
          //             gradient: LinearGradient(
          //                 colors: [Colors.green, Colors.teal]),
          //             child: Card(color: Colors.blue)))),
        }

        if (state.queryStatus == QueryStatus.loading) {
          return const LoadingLayout();
        }

        if (state.queryStatus == QueryStatus.loaded && state.response.isEmpty) {
          return Column(
            children: [
              Image.asset(
                'assets/gifs/sitting-alone.gif',
                width: 200,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Not found in your locaiton.\nSwitch off Branch filter to see more results from other branches',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Kindly add it when you find it.',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          );
        }

        if (state.queryStatus == QueryStatus.noResult) {
          return Column(
            children: [
              Image.asset('assets/gifs/animated_search.gif'),
              Text(
                'No Result Found...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Kindly add it when you find it.',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          );
        }
        return SizedBox(
          child: Text(state.errorMessage),
        );
      },
      listener: (context, state) {
        if (state.queryStatus == QueryStatus.loaded &&
            !state.hasReachedMax &&
            !_scrollController.hasClients) {
          print('fake bottom: no scrollbar');
          context.read<PartqueryManagerCubit>().moreResult();
        }
      },
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
