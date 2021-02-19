import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/config.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/models/crud_task.dart';
import 'package:todo_app/screen/add_new_page.dart';
import 'package:todo_app/screen/view_info_task.dart';

// ignore: must_be_immutable
class BuildTaskSearch extends StatelessWidget {
  QueryDocumentSnapshot task;
  BuildTaskSearch({this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Get.to(ViewInfoTask(task: task));
        },
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                //* Task
                Slidable(
                  showAllActionsThreshold: 1,
                  actionPane: SlidableDrawerActionPane(),
                  child: Container(
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //* icon status
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(5),
                          child: task['status'] == 'wait'
                              ? Icon(Icons.access_time_sharp,
                                  color: Colors.black12)
                              : task['status'] == 'done'
                                  ? Icon(
                                      CupertinoIcons.check_mark_circled_solid,
                                      color: Colors.green[300])
                                  : Icon(Icons.block_flipped,
                                      color: Colors.red),
                        ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              task['name'],
                              style: TextStyle(color: Colors.black45),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          // decoration: BoxDecoration(color: Colors.black12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                task['expired_at'].toDate().day > 9
                                    ? '${task['expired_at'].toDate().day} Tháng ${task['expired_at'].toDate().month}'
                                    : '0${task['expired_at'].toDate().day} Tháng 0${task['expired_at'].toDate().month}',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ),
                              // Text(
                              //   '${getNameWeekDay(task['expired_at'].toDate().weekday)}',
                              //   style: TextStyle(
                              //     color: Colors.black45,
                              //   ),
                              // ),
                              Text(
                                task['expired_at'].toDate().minute > 9
                                    ? '${task['expired_at'].toDate().hour}:${task['expired_at'].toDate().minute}'
                                    : '${task['expired_at'].toDate().hour}:0${task['expired_at'].toDate().minute}',
                                style: TextStyle(color: Colors.black45),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
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
                                children: [Icon(Icons.edit), Text('Chỉnh sửa')],
                              ),
                            ),
                          )
                        ]
                      : null,
                  secondaryActions: [
                    InkWell(
                      onTap: () async {
                        BackgroundWorkManager.cancelTask(uniqueName: task.id);
                        CRUDTask.deleteTask(task);
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
