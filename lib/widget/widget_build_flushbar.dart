import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ShowFlushbar {
  static showSuccecs({String title = 'Thành Công', String message}) {
    Flushbar(
        icon: Icon(
          CupertinoIcons.check_mark_circled,
          size: 28.0,
          color: Colors.green[300],
        ),
        backgroundColor: Colors.black54,
        title: title,
        message: message,
        duration: Duration(seconds: 2))
      ..show(currentContext);
  }

  static showError({String title = 'Thất Bại', String message}) {
    Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red[300],
        ),
        backgroundColor: Colors.black54,
        title: title,
        message: message,
        duration: Duration(seconds: 2))
      ..show(currentContext);
  }
}
