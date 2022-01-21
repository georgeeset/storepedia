import 'package:flutter/material.dart';
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;
import 'package:store_pedia/widgets/back_button.dart';

class PageLayout extends StatelessWidget {
  const PageLayout(
      {required this.body,
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
            hasBackButton
                ? Positioned(top: 10, left: 10, child: BackButtonWidget())
                : Container(),

            Positioned(
              top: 20,
              child: Container(
                width: sizeData.width,
                child: Center(child: title),
              ),
            ), // clipBehavior: Clip.antiAliasWithSaveLayer,
            Positioned(
              top: NumberConstants.appbarHeight,
              child: Container(
                padding: EdgeInsets.only(bottom: 60),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
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
