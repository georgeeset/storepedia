import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.purple,
      onTap: () {
        if (Navigator.of(context).canPop()) Navigator.pop(context);
      },
      child: Hero(
        tag: 'backButton',
        child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.arrow_back,
            size: 32,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
