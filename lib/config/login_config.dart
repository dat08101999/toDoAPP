import 'package:flutter/material.dart'
    show
        Colors,
        TextStyle,
        BorderSide,
        BoxDecoration,
        LinearGradient,
        Text,
        Color,
        TextAlign;

class LoginConfig {
  static double headerPadding = 70;
  static double headerHeigth = 0.4;
  static double textFieldAreaHeigth = 0.6;
  static double logoSize = 150;
  static Text loginTexttitle() =>
      Text('Chào mừng tới TODO APP , quản lý công việc một cách dễ dàng !',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black45, fontSize: 18));
  static Color logintheme = Colors.grey[200];
  static BorderSide borderSideTextFiled = BorderSide(color: Colors.black);
  static BoxDecoration decorationColors() => BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue[200], Colors.red[100]]),
      );
}
