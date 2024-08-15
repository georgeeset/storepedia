import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

import '../screens/home_page/home_page.dart';

class OnlinePhotoviewDialog extends StatefulWidget {
  const OnlinePhotoviewDialog({required this.photoLink, super.key});
  final String photoLink;
  static String routeName = "/photo_view";

  @override
  State<OnlinePhotoviewDialog> createState() => _OnlinePhotoviewDialogState();
}

class _OnlinePhotoviewDialogState extends State<OnlinePhotoviewDialog> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: NetworkImage(widget.photoLink),
            ),
            Positioned(
                top: 20,
                left: 20,
                child: InkWell(
                  splashColor: Colors.purple,
                  onTap: () {
                    if (context.canPop()) {
                      context.pop(context);
                    } else {
                      context.pushReplacement(HomePage.routeName);
                    }
                  },
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.blue,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
