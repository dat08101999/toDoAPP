import 'package:flutter/material.dart';

class LoginConfig {
  static double headerPadding = 70;
  static double headerHeigth = 0.4;
  static double textFieldAreaHeigth = 0.6;
  static double logoSize = 100;
  static Text loginTexttitle() => Text('Wellcome');
  static Color logintheme = Colors.grey[200];
  static BorderSide borderSideTextFiled = BorderSide(color: Colors.black);
  static BoxDecoration decorationColors() => BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue[200], Colors.red[100]]),
      );
}
