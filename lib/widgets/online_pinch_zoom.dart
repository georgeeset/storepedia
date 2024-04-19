import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:storepedia/widgets/conditional_image.dart';

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
                image: ConditionalImage(
                  imageUrl: link!,
                )),
          );
  }
}
