import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_app/config/config.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/models/crud_task.dart';
import 'package:todo_app/screen/view_info_task.dart';
import 'package:todo_app/widget/widget_build_scroll_date.dart';

class BuildTaskDoneItem extends StatelessWidget {
  final QueryDocumentSnapshot task;

  BuildTaskDoneItem({this.task});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        //* icon status
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * 0.0310,
                          width: Get.width * 0.064,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: task['status'] == 'wait'
                              ? Icon(Icons.access_time_sharp,
                                  color: Colors.white70)
                              : task['status'] == 'done'
                                  ? Icon(
                                      CupertinoIcons.check_mark_circled_solid,
                                      color: Colors.green[300])
                                  : Icon(Icons.block_flipped,
                                      color: Colors.red),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          // decoration: BoxDecoration(color: Colors.black12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${task['expired_at'].toDate().day} Tháng ${task['expired_at'].toDate().month}',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${getNameWeekDay(task['expired_at'].toDate().weekday)}',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
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
                  secondaryActions: [
                    InkWell(
                      onTap: () async {
                        BackgroundWorkManager.cancelTask(
                            uniqueName:
                                '${task['name']}-${task['expired_at'].toDate()}');
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
