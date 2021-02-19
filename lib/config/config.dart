import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart'
    show
        Colors,
        TextStyle,
        Icons,
        IconData,
        LinearGradient,
        FontWeight,
        Alignment;

class ConfigTheme {}

class ConfigText {
  static final TextStyle textStyle = TextStyle(
      color: Colors.grey.withOpacity(0.7), fontWeight: FontWeight.bold);
}

class ConfigColor {
  static LinearGradient getGradient(int index) {
    List<LinearGradient> listLinearGradient = [
      LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.red[200], Colors.yellow[200]]),
      LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.deepPurple[200], Colors.blue[200]]),
      LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue[600], Colors.blue[100]]),
      LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [Colors.blue[300], Colors.white70]),
      LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue[300], Colors.deepPurple[300]]),
      LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.black87, Colors.grey[100]]),
      LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.teal, Colors.pink[400]]),
    ];
    return listLinearGradient[index];
  }
}

class ConfigIcon {
  static List<IconData> listIconTask = [
    Icons.notifications,
    Icons.shopping_bag,
    CupertinoIcons.location,
    Icons.party_mode,
    Icons.airline_seat_flat_rounded,
    Icons.attachment,
    Icons.audiotrack_rounded
  ];

  static IconData getIcon(int index) {
    return listIconTask[index];
  }
}
