import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/config.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/screen/add_new_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class BuildTaskItem extends StatelessWidget {
  final QueryDocumentSnapshot task;
  BuildTaskItem({this.task});

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
                  Slidable(
                    showAllActionsThreshold: 1,
                    actionPane: SlidableDrawerActionPane(),
                    child: Container(
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
                                gradient: ConfigColor.getGradient(task['icon']),
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              ConfigIcon.getIcon(task['icon']),
                              size: 20,
                              color: Colors.white70,
                            ),
                          ),
                          //* Name
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                task['name'],
                                style: TextStyle(color: Colors.black45),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          //* icon status
                          Container(
                            height: Get.height * 0.0310,
                            width: Get.width * 0.064,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient: ConfigColor.getGradient(task['icon']),
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              task['status'] == 'wait'
                                  ? Icons.access_time_sharp
                                  : task['status'] == 'done'
                                      ? CupertinoIcons.check_mark_circled_solid
                                      : Icons.remove,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: task['status'] == 'wait'
                        ? [
                            InkWell(
                              onTap: () {
                                Get.to(AddNewPage(task: task));
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.green[300],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit),
                                    Text('Chỉnh sửa')
                                  ],
                                ),
                              ),
                            )
                          ]
                        : null,
                    secondaryActions: [
                      InkWell(
                        onTap: () async {
                          BackgroundWorkManager.cancelTask(
                              uniqueName:
                                  '${task['name']}-${task['expired_at'].toDate()}');
                          await FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(task.id)
                              .delete();
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.red[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.delete), Text('Xóa Bỏ')],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
