import 'package:flutter/material.dart';
import 'package:storepedia/constants/number_constants.dart' as NumberConstants;

class PageLayout extends StatelessWidget {
  const PageLayout(
      {super.key, required this.body,
      required this.title,
      this.hasBackButton = false,
      this.levelIndicator});
  final Widget title;
  final Widget body;
  final bool hasBackButton;
  final Widget? levelIndicator;

  @override
  Widget build(BuildContext context) {
    final Size sizeData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: sizeData.height / 2.5,
                width: sizeData.width,
                color: Colors.blue,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: hasBackButton
                  ? InkWell(
                      splashColor: Colors.purple,
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.pop(context);
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
                    )
                  : Container(),
            ),

            Positioned(
              top: 20,
              child: SizedBox(
                width: sizeData.width,
                child: Center(child: title),
              ),
            ), // clipBehavior: Clip.antiAliasWithSaveLayer,
            Positioned(
              top: NumberConstants.appbarHeight,
              child: Container(
                padding: const EdgeInsets.only(bottom: 60),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: sizeData.width / 1.05,
                height: sizeData.height - NumberConstants.appbarHeight,
                child: body,
              ),
            ),
            levelIndicator != null
                ? Positioned(
                    top: NumberConstants.appbarHeight,
                    child: levelIndicator!,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
