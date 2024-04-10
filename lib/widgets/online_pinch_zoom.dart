import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

class OnlinePinchZoomImage extends StatelessWidget {
  const OnlinePinchZoomImage({super.key, required this.link});
  final String? link;
  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;

    return link == null
        ? Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/main_logo.jpg'),
              const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(),
              )
            ],
          )
        : Hero(
            tag: link!,
            child: PinchZoomImage(
              zoomedBackgroundColor: Colors.black12,
              //hideStatusBarWhileZooming: true,
              image: CachedNetworkImage(
                imageUrl: link!,
                fit: BoxFit.contain,
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
                },
                errorWidget: (context, _, __) =>
                    Image.asset('assets/images/main_logo.jpg'),
              ),
            ),
          );
  }
}
