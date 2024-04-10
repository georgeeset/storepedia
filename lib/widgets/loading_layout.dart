import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class LoadingLayout extends StatelessWidget {
  const LoadingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blue.shade50,
      highlightColor: Colors.white,
      child: StaggeredGridView.countBuilder(
        //gridDelegate: SliverStaggeredGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 100,mainAxisSpacing: 10, staggeredTileBuilder: (int index) { return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8); },),
        itemCount: 4,
        //shrinkWrap: true,
        itemBuilder: (context, index) => const Card(color: Colors.blue),
        crossAxisCount: 2,
        staggeredTileBuilder: (int index) {
          return StaggeredTile.count(1, index.isEven ? 1.4 : 1.8);
        },
        //Text(state.response[index].partName!)
      ),
    );
  }
}
