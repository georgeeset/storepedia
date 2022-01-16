import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:store_pedia/model/image_shower_args.dart';
import 'package:store_pedia/widgets/back_button.dart';

class ImageShower extends StatelessWidget {
  static final String routeName = '/image_shower';
  // final String imageLink;
  // final String hero;

  // ImageShower({
  //   required this.imageLink,
  //   required this.hero,
  // });
  @override
  Widget build(BuildContext context) {
    //final MediaQueryData mediaQueryData=MediaQuery.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as ImageShowerData;
    String imageLink = args.imageLink;
    String hero = args.hero;
    return Scaffold(
      //insetAnimationDuration: Duration(milliseconds: 900),
      backgroundColor: Colors.black,

      //appBar: AppBar(backgroundColor: Colors.black,),
      body: Stack(
        children: <Widget>[
          PhotoView(
            imageProvider: CachedNetworkImageProvider(
              imageLink,
            ),
            // Contained = the smallest possible size to fit one dimension of the screen
            minScale: PhotoViewComputedScale.contained * 0.8,
            // Covered = the smallest possible size to fit the whole screen
            maxScale: PhotoViewComputedScale.covered * 2,
            enableRotation: false,

            loadingBuilder: (context, imageChunkEvent) {
              // double progress= imageChunkEvent==null? 0.0: ((imageChunkEvent.expectedTotalBytes-imageChunkEvent.cumulativeBytesLoaded)/imageChunkEvent.expectedTotalBytes)*100;
              return Center(
                  child: Container(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ))); //value:progress)));
            },
            heroAttributes: PhotoViewHeroAttributes(
              tag: hero,
            ),
          ),
          Positioned(top: 50, left: 20, child: BackButtonWidget()),
        ],
      ),
    );

    //     return Dialog(
    //       backgroundColor: Colors.black12,
    //       child: CachedNetworkImage(
    //     imageUrl: imageLink,
    //     imageBuilder: (context, imageProvider) => PhotoView(
    //         imageProvider: imageProvider,
    //     ),
    //     placeholder: (context, url) =>
    //         CircularProgressIndicator(),
    //         errorWidget: (context, url, error) =>
    //             Icon(Icons.error),
    // ),
    //     );
  }
}
