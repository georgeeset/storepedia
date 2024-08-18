import 'package:flutter/material.dart';
import 'package:storepedia/cubit/exhausted_items_manager_cubit/cubit/exhausteditemsmanager_cubit.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/widgets/loading_layout.dart';
import 'package:storepedia/widgets/one_part.dart';
import 'package:storepedia/widgets/page_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/number_constants.dart' as number_constants;

class ExhaustedItemsPage extends StatelessWidget {
  static String routName = '/exhausted-items-page';
  static String name = 'exhausted-items';

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
    return BlocConsumer<ExhausteditemsmanagerCubit, ExhausteditemsmanagerState>(
      builder: (context, state) {
        if (state.queryStatus == QueryStatus.loaded) {
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
      },
      listener: (BuildContext context, ExhausteditemsmanagerState state) {
        if (state.queryStatus == QueryStatus.loaded &&
            !state.hasReachedMax &&
            !_scrollController.hasClients) {
          print('fake bottom: no scrollbar');
          context.read<ExhausteditemsmanagerCubit>().moreExhaustedItems();
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
