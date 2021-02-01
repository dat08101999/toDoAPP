import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/controller_home.dart';

class BuildReMoteMonth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white70),
            onPressed: () {
              Get.find<ControllerHome>().comeBackMothAlert();
              Get.find<ControllerHome>().pageController.animateToPage(
                  Get.find<ControllerHome>().currentDay - 1,
                  duration: Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn);
            }),
        Container(
          child: Text(
            'Tháng ${Get.find<ControllerHome>().currentMonth} / ${Get.find<ControllerHome>().currentYear}',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white70),
            onPressed: () {
              Get.find<ControllerHome>().nextMothBefore();
              Get.find<ControllerHome>().pageController.animateToPage(
                  Get.find<ControllerHome>().currentDay - 1,
                  duration: Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn);
            }),
      ],
    );
  }
}
