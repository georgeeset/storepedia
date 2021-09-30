import 'package:flutter/material.dart';

class ActionDialog extends StatelessWidget {
  /// title text displays on top of the dialog page
  final String titleText;

  /// inform the user what he/she is about to do
  final String bodyText;

  /// When good option is clicked,
  /// the widget returns false.
  final String goodOption;

  /// when bad option is clicked,
  /// the widget returns true.
  final String? badOption;


  ActionDialog(
      {required this.titleText, required this.bodyText, required this.goodOption,this.badOption,});

  @override
  Widget build(BuildContext context) {
    final Size pageSize= MediaQuery.of(context).size;
    return AlertDialog(
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Icon(
          Icons.warning,
          color: Colors.red,
          size: 20,
        ),
        Container(padding: EdgeInsets.symmetric(horizontal: 10),width:pageSize.width, child: Text(titleText,softWrap: true,))
      ]),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      content: Container(
        padding: EdgeInsets.all(10),
        child: Text(bodyText, softWrap: true,),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(goodOption),
        ),
        Container(
          width: 20,
        ),
        badOption!=null
        ?OutlinedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(badOption!),
        )
        :Container(),
      ],
      contentTextStyle: TextStyle(
        color: Colors.black,
      ),
    );
  }
}
