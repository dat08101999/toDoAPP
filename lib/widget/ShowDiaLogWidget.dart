import 'package:flutter/material.dart';

class ShowDialogWidget {
  static showDialogloading(context, String title) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        child: AlertDialog(
          title: Container(
            child: Column(
              children: [CircularProgressIndicator(), Text(title)],
            ),
          ),
        ));
  }

  static showDialogResuld(context, String title, String content) {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text(title),
          content: Text(content),
        ));
  }

  static showDialogAcept(
      context, String title, String content, Function() acceptPress) {
    return showDialog(
        context: context,
        child: AlertDialog(
            title: Text(title),
            content: FlatButton(
              child: Text(content),
              onPressed: () {
                acceptPress();
              },
            )));
  }
}
