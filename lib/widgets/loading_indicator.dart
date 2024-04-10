import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:50.0,
      height: 50.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color:Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(
                0.0,
                0.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 7.0,
            ),
          ],
        ),
        child: const CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
  }
}
