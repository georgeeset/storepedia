import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ConditionalImage extends StatelessWidget {
  const ConditionalImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        imageUrl,
      );
    } else {
      // Web platform: use Image.network from the image package
      return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, data) {
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
          });
    }
  }
}
