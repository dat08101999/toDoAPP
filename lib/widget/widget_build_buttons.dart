import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildWidget {
  ///* phải đặt vào thẻ InkWell
  static Widget buildContainerGradient(
      {@required var title,
      MaterialColor color1 = Colors.blue,
      MaterialColor color2 = Colors.blue}) {
    return Container(
      width: Get.width * 0.3,
      height: Get.height * 0.0507,
      decoration: BoxDecoration(
          boxShadow: [boxShadow()],
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color1[600], color2[200]])),
      child: Center(
          child: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))),
    );
  }

  static BoxShadow boxShadow() {
    return BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    );
  }
}
