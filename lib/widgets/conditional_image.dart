import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ConditionalImage extends StatelessWidget {
  const ConditionalImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Container(
        constraints: const BoxConstraints(maxHeight: 500),
        child: Image.network(
          imageUrl,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return child;
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return loadingStack();
            }
            // return ;
          },
        ),
      );
    } else {
      // Web platform: use Image.network from the image package
      return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, data) {
            return loadingStack();
          });
    }
  }

  Widget loadingStack() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/bin.jpg'),
        const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
