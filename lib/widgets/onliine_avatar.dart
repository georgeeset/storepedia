import 'package:flutter/material.dart';
import 'package:storepedia/widgets/conditional_image.dart';

class OnlineAvatar extends StatelessWidget {
  final bool editable;
  final double radius;
  final Color ringColor;
  final String? imageLink;
  final Function editClicked;
  final bool enableEnlarge;
  final String heroTag;

  const OnlineAvatar(
      {super.key,
      this.editable = false,
      required this.radius,
      this.ringColor = Colors.purple,
      this.imageLink,
      required this.editClicked,
      this.enableEnlarge = true,
      required this.heroTag});

  @override
  Widget build(BuildContext context) {
    // print('online avatar build');
    return Center(
      child: Stack(
        children: <Widget>[
          Hero(
            tag: heroTag,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: ringColor,
              child: ClipOval(
                child: Container(
                  height: radius * 1.9,
                  width: radius * 1.9,
                  color: Colors.green,
                  child: imageLink == null
                      ? Image.asset('assets/images/user_logo.png')
                      : ConditionalImage(imageUrl: imageLink!),
                ),
              ),
            ),
          ),
          editable == true
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.black38,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        editClicked();
                      },
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
