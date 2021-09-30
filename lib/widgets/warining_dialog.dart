import 'package:flutter/material.dart';
import 'action_dialog.dart';

class WarningDialog {
  static Future<bool?> boolActionsDialog({
    required BuildContext context,   
    
    /// title text displays on top of the dialog page
    required String titleText,
    
    /// inform the user what he/she is about to do
    required String bodyText, 
    
    /// When good option is clicked,
    /// the widget returns false.
    required String goodOption,
    
    /// when bad option is clicked,
    /// the widget returns true.
    String? badOption, 

    ///If set to true, the dialog box will not
    /// exit till an option is selected.
    bool isDismissible=true,

  }) async {
    return showGeneralDialog(
      barrierColor: Colors.black38,
      transitionDuration: Duration(milliseconds: 300),
      barrierDismissible: isDismissible,
      barrierLabel: '',
      context: context,
      
      transitionBuilder: (context, animation1, animation2, widget) {
        final curvedValue =
            Curves.easeInOutBack.transform(animation1.value) - 1.0;

        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
              opacity: animation1.value,
              child: ActionDialog(
                titleText: titleText,
                bodyText: bodyText,
                goodOption: goodOption,
                badOption: badOption,
              )),
        );
      }, pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) { return Container();  },
    );
  }
}
