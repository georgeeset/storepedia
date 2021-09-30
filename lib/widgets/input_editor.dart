

import 'package:flutter/material.dart';
import '../repository/validator.dart';

class SignupFormDialog {
  static void formDialog({
    required BuildContext context,
    required Function onSubmit,
    required String title,
    TextInputType? textInputType,
    TextCapitalization? textCapitalization,
    String? initialValue,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal:10),

            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(title, style: TextStyle(fontSize: 20.0, color: Colors.blue),),
                  Container(height: 10.0,),
                  TextInputField(
                    onSubmit: onSubmit,
                    title: title,
                    textInputType: textInputType,
                    textCapitalization: textCapitalization,
                    initialValue: initialValue,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class TextInputField extends StatefulWidget {
  //const PhoneInputField({Key key,}) : super(key: key);
  final Function onSubmit;
  final String title;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final String? initialValue;
  TextInputField({
    required this.onSubmit,
    required this.title,
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
    this.initialValue,
  });
  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  TextEditingController? textEditingController;
  late Validator validator;
  String? err;
  //var _userProfile=Provider.of<ProfileProvider>(context,listen: false);

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.initialValue);
    validator = Validator();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: widget.textInputType,
      enabled: true,
      autofocus: true,
      textAlign: TextAlign.justify,
      textInputAction: TextInputAction.done,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      onChanged: (val) {
        setState(() {
          err = validator.validateString(val);
        });
      },
      onSubmitted: (val) async {
        if (err == null) {
          widget.onSubmit(val);
          Navigator.pop(context);
        }
      },
      decoration: InputDecoration(
        errorText: err,
        hintText: widget.title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),

        //fillColor:Theme.of(context).primaryColor,
        //filled: true

        suffix: Icon(Icons.check),
      ),
    );
  }
}
