import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/background_workmaneger.dart';
import 'package:todo_app/models/crud_task.dart';
import 'package:todo_app/models/loading.dart';

// ignore: must_be_immutable
class MenuLoopDelete extends StatelessWidget {
  QueryDocumentSnapshot task;
  MenuLoopDelete({this.task});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        height: Get.height * 0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                Navigator.pop(context);
                Loading.show();
                await CRUDTask.deleteTaskList(task);
                Loading.dismiss();
                Flushbar(
                    icon: Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 28.0,
                      color: Colors.green[300],
                    ),
                    backgroundColor: Colors.black54,
                    title: 'Thành Công',
                    message: 'Đã xóa lịch này trong các tháng sau',
                    duration: Duration(seconds: 2))
                  ..show(navigatorKey.currentContext);
                await Future.delayed(Duration(seconds: 2));
              },
              child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  child: Text('Xoá Cả Những Ngày Sau')),
            ),
            InkWell(
              onTap: () async {
                BackgroundWorkManager.cancelTask(uniqueName: task.id);
                CRUDTask.deleteTask(task);
                Navigator.pop(context);
              },
              child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  child: Text('Chỉ Xóa Hôm Nay')),
            ),
          ],
        ),
      ),
    );
  }
}
