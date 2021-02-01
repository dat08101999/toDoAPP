import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/controller_add_page.dart';
import 'package:todo_app/controller/controller_home.dart';
import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class BuildTaskItem extends StatelessWidget {
  final int index;
  final QueryDocumentSnapshot task;
  BuildTaskItem({this.task, this.index});
  ControllerHome _controllerHome = Get.put(ControllerHome());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        columnWidths: {0: FlexColumnWidth(0.13), 1: FlexColumnWidth(0.06)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              //* Thời gian
              Text(
                '${task['expired_at'].toDate().hour}:${task['expired_at'].toDate().minute}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    fontSize: 16),
              ),
              //* Nút tròn xanh
              Container(
                height: 10,
                width: 10,
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue[100],
                ),
              ),
              //* Task
              Column(
                children: [
                  Container(
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //* Icon
                        Container(
                          height: Get.height * 0.0310,
                          width: Get.width * 0.064,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomLeft,
                                  colors: [Colors.blue[200], Colors.red[100]]),
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            ControllerAddNew().getItemIconTask(task['icon']),
                            size: 20,
                            color: Colors.white70,
                          ),
                        ),
                        //* Name
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              task['name'],
                              style: TextStyle(color: Colors.black45),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    curve: Curves.easeInCirc,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    duration: Duration(seconds: 3),
                    height: (_controllerHome.indexpage == index &&
                            _controllerHome.actionActive)
                        ? Get.height * 0.05
                        : 0,
                    width: (_controllerHome.indexpage == index &&
                            _controllerHome.actionActive)
                        ? Get.width
                        : 0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Colors.amber),
                    child: Text('-------'),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
