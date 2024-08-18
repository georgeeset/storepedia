import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/number_constants.dart' as number_constants;

class LoadingLayout extends StatelessWidget {
  const LoadingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blue.shade50,
      highlightColor: Colors.white,
      child: Wrap(
          //shrinkWrap: true,
          children: [
            for (int i = 0; i < 5; i++)
              Card(
                color: Colors.blue,
                child: Container(
                  constraints: const BoxConstraints(
                      maxHeight: number_constants.onePartMaxHeight),
                  child: const AspectRatio(aspectRatio: 3 / 5),
                ),
              ),
          ]
          //Text(state.response[index].partName!)
          ),
    );
  }
}
