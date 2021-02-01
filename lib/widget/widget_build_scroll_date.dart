import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/controller_home.dart';

// ignore: must_be_immutable
class BuildScrollDate extends StatelessWidget {
  ControllerHome _controllerHome = Get.find<ControllerHome>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.121,
      child: PageView.builder(
        pageSnapping: false, // cuộn nhanh khi người dùng vuốt mạnh
        onPageChanged: (index) {
          _controllerHome.currentDay = _controllerHome.listday[index].day;
        },
        controller: _controllerHome.pageController,
        itemCount: _controllerHome.listday.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              margin: index != _controllerHome.currentDay - 1
                  ? EdgeInsets.symmetric(vertical: 10)
                  : null,
              decoration: BoxDecoration(
                  boxShadow: index != _controllerHome.currentDay - 1
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: index != _controllerHome.currentDay - 1
                          ? [Colors.white54, Colors.white54]
                          : [Colors.white38, Colors.blue[400]]),
                  borderRadius: _controllerHome.currentDay - 1 != index
                      ? null
                      : BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_controllerHome.listday[index].day} / ${_controllerHome.listday[index].month}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: index != _controllerHome.currentDay - 1
                            ? Colors.black54
                            : Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    getNameWeekDay(_controllerHome.listday[index].weekday),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: index != _controllerHome.currentDay - 1
                            ? Colors.black54
                            : Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String getNameWeekDay(int id) {
  List weekDay = [
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 7',
    'Chủ Nhật'
  ];
  return weekDay[id - 1];
}
