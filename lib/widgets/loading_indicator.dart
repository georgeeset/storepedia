import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:50.0,
      height: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: const Offset(
                0.0,
                0.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 7.0,
            ),
          ],
        ),
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
  }
}
