import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

class OnlinePinchZoomImage extends StatelessWidget {
  const OnlinePinchZoomImage({Key? key, required this.link}) : super(key: key);
  final String? link;
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return link == null
        ? Container(
            child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/main_logo.jpg'),
              Container(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(),
              )
            ],
          ))
        : Container(
            //width: _size.height / 2.2,
            // height: _size.height / 2,
            child: Hero(
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
                        Container(
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
            ),
          );
  }
}
