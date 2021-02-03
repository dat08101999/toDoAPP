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
}
