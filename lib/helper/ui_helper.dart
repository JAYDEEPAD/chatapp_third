import 'package:flutter/material.dart';

class UiHelper {
  static void showLoadingDialog(BuildContext context) {
    AlertDialog loadingDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CircularProgressIndicator()],
        ),
      ),
    );
    showDialog(
      context: context,
      // not close dialog when user tap screen
      barrierDismissible: false,
      builder: (context) {
        return loadingDialog;
      },
    );
  }
  static void showAlertDialog(BuildContext context,String title,String content) {
    AlertDialog loadingDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Ok"))
      ],
    );
    showDialog(
      context: context,
      // not close dialog when user tap screen
      barrierDismissible: false,
      builder: (context) {
        return loadingDialog;
      },
    );
  }
}
