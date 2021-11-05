

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../repository/validator.dart';

class SignupFormDialog {
  static void formDialog({
    required BuildContext context,
    required Function onSubmit,
    required String title,
    TextInputType? textInputType,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    String? initialValue,
    bool noSpace=false,
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
                    noSpace:noSpace,
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
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final bool noSpace;
  TextInputField({
    required this.onSubmit,
    required this.title,
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
    this.initialValue,
    required this.noSpace,
  });
  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  TextEditingController? textEditingController;
  //MaskedTextController controller
  late Validator validator;
  String? err;
  //var _userProfile=Provider.of<ProfileProvider>(context,listen: false);

  @override
  void initState() {
    super.initState();
   textEditingController= TextEditingController(text: widget.initialValue);
    validator = Validator();
  }

  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              keyboardType: widget.textInputType,
              enabled: true,
              autofocus: true,
              textAlign: TextAlign.justify,
              textInputAction: TextInputAction.done,
              textCapitalization: widget.textCapitalization,
              onChanged: (val) {
                setState(() {
                  print(widget.noSpace);
                  err = widget.noSpace==false? validator.validateString(val): validator.validateStringWithoutSpace(val);
                });
              },
              onSubmitted: (val) async {
               submitField();
              },
              decoration: InputDecoration(
                errorText: err,
                hintText: widget.title,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
          
                //fillColor:Theme.of(context).primaryColor,
                //filled: true
              
              ),
            ),
          ),
                IconButton(icon:Icon(Icons.check_circle_outline, size:30), onPressed:()=> submitField(),),
        ],
      ),
    );
  }

  void submitField(){
     if (err == null && textEditingController!.text.isNotEmpty) {
          widget.onSubmit(textEditingController!.text);
          Navigator.pop(context);
        }
  }
}

